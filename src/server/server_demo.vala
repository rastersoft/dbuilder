using GLib;
using Gtk;
using DBuilder;
//using GIO;

class server : GLib.Object {

	private Gtk.Builder global_builder;

	private void on_bus_aquired (DBusConnection conn) {
		try {
		    // start service and register it as dbus object
		    var service = new DBuilder.DBuilderServer(this.global_builder);
		    conn.register_object ("/com/rastersoft/dbuilder", service);
		    GLib.stdout.printf("Service registered\n");
		} catch (IOError e) {
		    GLib.stderr.printf ("Could not register service: %s\n", e.message);
		}
	}

	public server(string[] argv) {

		Gtk.init(ref argv);

		this.global_builder = new Gtk.Builder();

		Bus.own_name (BusType.SESSION, "com.rastersoft.dbuilder", /* name to register */
		              BusNameOwnerFlags.NONE, /* flags */
		              on_bus_aquired, /* callback function on registration succeeded */
		              () => {GLib.stdout.printf("Callback\n");}, /* callback on name register succeeded */
		              () => GLib.stderr.printf ("Could not acquire name\n"));
		                                                 /* callback on name lost */
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
