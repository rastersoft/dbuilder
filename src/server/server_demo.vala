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
using DBuilderApplet;
//using GIO;

class server : GLib.Object {

	private Gtk.Builder global_builder;
	private DBuilderApplet.DBuilderAppletServer server;
	private Gtk.Window w;

	public server(string[] argv) {

		Gtk.init(ref argv);

		this.server = new DBuilderApplet.DBuilderAppletServer(Gtk.Orientation.HORIZONTAL,0);
		
		this.w = new Gtk.Window();
		w.add(this.server);
		w.show_all();
		
	}

	public void run_server() {

		Gtk.main();
	}
}




int main(string[] argv) {

	var oserver = new server(argv);
	oserver.run_server();

	return 0;
}
