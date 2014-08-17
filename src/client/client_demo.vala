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

//using GIO;
using Gtk;
using GLib;
using Gee;
using DBuilderApplet;
using Posix;

public class client : DBuilder.DBuilderClient {

	private DBuilder.DBuilder builder;
	private Gtk.Builder builder2;
	private DBuilderApplet.DBuilderApplet applet;

	public void on_button_clicked(string obj) {
		var w = (Gtk.Label)this.builder2.get_object("label1");
		w.set_text("Button clicked");
	}

	public void on_entry1_changed(string obj) {
		var w = (Gtk.Label)this.builder2.get_object("label2");
		w.set_text(this.builder.get_string("entry1","text"));
	}

	/** When the user changes the Gtk.Entry in the client window, this callback
	    updates the remote label */
	private void changed_entry() {

		var w = (Gtk.Entry)this.builder2.get_object("entry1");
		this.builder.set_string("label","label",w.get_text());

	}

	public client(string[] argv) {
	
		Gtk.init(ref argv);

		/* This code creates the client window */
		this.builder2 = new Gtk.Builder();
		this.builder2.add_from_file(GLib.Path.build_filename(Constants.PKGDATADIR,"iface_test2.ui"));
		var w = (Gtk.Window)this.builder2.get_object("window1");
		w.show_all();
		var w2 = (Gtk.Entry)this.builder2.get_object("entry1");
		w2.changed.connect(this.changed_entry);


		this.applet = Bus.get_proxy_sync<DBuilderApplet.DBuilderApplet> (BusType.SESSION, "com.rastersoft.dbuilderapplet", "/com/rastersoft/dbuilderapplet");
		this.applet.add_applet("prueba_applet","document-open",DBuilderApplet.Cathegory.OTHER);
		this.applet.set_gui("prueba_applet",GLib.Path.build_filename(Constants.PKGDATADIR,"iface_test.ui"),"box1");

		this.builder = this.create_client("com.rastersoft.dbuilderapplet","/com/rastersoft/dbuilderapplet/prueba_applet");
		// Loads this UI file
		//this.builder.add_from_file();
		// And now requests to the remote Gtk.Builder to send the "clicked" signals generated,
		// as defined in Glade
		this.builder.connect_signals();
		// We could use "connect_signal" to manually connect signals and widgets to methods, like:
		//this.builder.connect_signal("clicked","button","client_on_button_clicked");
		//this.builder.connect_signal("changed","entry1","client_on_entry1_changed");

		// Finally, requests to show the remote window
		//this.builder.show_all_widget("window1");
	}

	public void run() {
		Gtk.main();
	}

}

int main(string[] argv) {

	var c = new client(argv);
	c.run();
	return 0;
}
