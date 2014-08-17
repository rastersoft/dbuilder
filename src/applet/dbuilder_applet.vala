/* DBuilder
 * Copyright (C) 2014 Sergio Costas Rodriguez (Raster Software Vigo)
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

using GLib;
using Gtk;
using DBuilder;
using Gee;
//using GIO;

namespace DBuilderApplet {

	public enum Status {PASSIVE, ACTIVE,  ATTENTION}
	public enum Cathegory {APPLICATION_STATUS, COMMUNICATIONS, SYSTEM_SERVICES, HARDWARE, OTHER}

	private class applet_element {
		public string id;
		public Cathegory cathegory;
		public string icon_active;
		public string? icon_attention;
		public Status current_status;
		public Gtk.Button btn;
		private Gtk.Builder? builder;
		private DBuilder.DBuilderServer? server;
		private Gtk.Popover? popover;
		
		public applet_element(string id, string icon_active, Cathegory cathegory) {
			this.icon_active = icon_active;
			this.cathegory = cathegory;
			this.id = id;
			this.icon_attention = null;
			this.current_status = Status.PASSIVE;
			this.btn = new Gtk.Button.from_icon_name(icon_active,Gtk.IconSize.MENU);
			this.btn.clicked.connect(this.button_event);
			this.builder = null;
			this.server = null;
			this.popover = null;
		}

		public void button_event(Gtk.Widget origin) {
			this.popover.show_all();
		}

		public bool set_gui(DBusConnection connection, string ui,string obj) {

			this.builder = new Gtk.Builder();
			string[] objects = {};
			objects += obj;
			this.builder.add_objects_from_file(ui,objects);
			this.server = new DBuilder.DBuilderServer(this.builder);

			try {
				connection.register_object ("/com/rastersoft/dbuilderapplet/%s".printf(id),this.server);
			} catch (IOError e) {
				return true;
			}

			this.popover = new Gtk.Popover(this.btn);
			var element = this.builder.get_object(obj) as Gtk.Widget;
			if (element == null) {
				return true;
			}
			this.popover.add(element);
			this.popover.set_position(Gtk.PositionType.LEFT);
			return false;
		}
	}

	[DBus(name = "com.rastersoft.dbuilderapplet")]
	public interface DBuilderApplet : GLib.Object {
	
		public abstract bool add_applet(string id, string icon, Cathegory cathegory) throws Error;
		public abstract bool set_gui(string id, string ui, string obj) throws Error;
	
	}

	[DBus(name = "com.rastersoft.dbuilderapplet")]
	public class DBuilderAppletServer : Gtk.Box {

		private Gee.List<applet_element> applets;
		private DBusConnection connection = null;

		[DBus(visible = false)]
		public DBuilderAppletServer(Gtk.Orientation orientation, int spacing) {

			this.applets = new Gee.ArrayList<applet_element>();
			Bus.own_name (BusType.SESSION, "com.rastersoft.dbuilderapplet", /* register the desired name */
	              BusNameOwnerFlags.NONE, /* flags */
	              on_bus_aquired, /* callback function on registration succeeded */
	              () => {GLib.stdout.printf("Callback\n");}, /* callback on name register succeeded */
	              () => GLib.stderr.printf ("Could not acquire name\n"));
	                                                 /* callback on name lost */
		}

		[DBus(visible = false)]
		private void on_bus_aquired (DBusConnection conn) {
			this.connection = conn;
			try {
				// start service and register it as dbus object
				conn.register_object ("/com/rastersoft/dbuilderapplet", this);
				GLib.stdout.printf("DBuilderApplet service registered\n");
			} catch (IOError e) {
				GLib.stderr.printf ("Could not register DBuilderApplet service: %s\n", e.message);
			}
		}

		[DBus(visible = false)]
		private applet_element? find_applet(string id) {
			foreach (var e in this.applets) {
				if (e.id == id) {
					return e;
				}
			}
			return null;
		}

		public bool add_applet(string id, string icon, Cathegory cathegory) {
			if (this.find_applet(id) != null) {
				return true; // that applet id already exists
			}
			var element = new applet_element(id,icon,cathegory);

			this.applets.add(element);
			this.pack_start(element.btn,false,false,1);
			element.btn.show_all();
			
			return false;
		}

		public bool set_gui(string id, string ui, string obj) {
		
			var element = this.find_applet(id);
			if (element == null) {
				return true;
			}
			element.set_gui(this.connection,ui,obj);
			return false;
		}

	}
}
