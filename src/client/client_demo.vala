//using GIO;
//using GModule;
using Gtk;
using GLib;
using Gee;

public class client : Object {

	private dbuilder builder;
	private Gtk.Builder builder2;
	private delegate void my_callback(client this,string obj);

	GLib.Module? module;

	/**
	 This callback receives the events produced by the remote widgets
	 and do the desired actions
	 */

	private void remote_event(string obj, string event, string callback_name) {

		GLib.stdout.printf("Received event %s from object %s, for callback %s\n", event, obj, callback_name);
		if (this.module != null) {
			void *my_symbol;
			if (this.module.symbol(callback_name, out my_symbol)) {
				((my_callback)my_symbol)(this,obj);
			} else {
				GLib.stdout.printf("Callback %s not found\n",callback_name);
			}
		} else {
			GLib.stdout.printf("Module is null\n");
		}
	}

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

		this.module = GLib.Module.open(null,0);

		/* This code creates the client window */
		this.builder2 = new Gtk.Builder();
		this.builder2.add_from_file(GLib.Path.build_filename(Constants.PKGDATADIR,"iface_test2.ui"));
		var w = (Gtk.Window)this.builder2.get_object("window1");
		w.show_all();
		var w2 = (Gtk.Entry)this.builder2.get_object("entry1");
		w2.changed.connect(this.changed_entry);

		/* This code connects to the remote Gtk.Builder server */

		try {
			this.builder = Bus.get_proxy_sync (BusType.SESSION, "com.rastersoft.dbuilder","/com/rastersoft/dbuilder");
		} catch (Error e) {
			GLib.stderr.printf("Error when connecting to the server: %s",e.message);
		}
		// Loads this UI file
		this.builder.add_from_file(GLib.Path.build_filename(Constants.PKGDATADIR,"iface_test.ui"));
		// Connect the signal that announces that an event has been sent from the server
		this.builder.sent_event.connect(this.remote_event);
		// And now requests to the remote Gtk.Builder to send the "clicked" signals generated by
		// the widget "button"
		//this.builder.connect_signal("clicked","button","client_on_button_clicked");
		// And the "changed" signals generated by the widget "entry1"
		//this.builder.connect_signal("changed","entry1","client_on_entry1_changed");
		this.builder.connect_signals();
		// Finally, requests to show the remote window
		this.builder.show_all_widget("window1");
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
