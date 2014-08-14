//using GIO;
using Gtk;
using GLib;
using Gee;

public class client : DBuilder.DBuilderClient {

	private DBuilder.DBuilder builder;
	private Gtk.Builder builder2;

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

		/* Here we create a new remote Gtk.Builder object and connect to it through DBus */
		this.builder = this.create_client("com.rastersoft.dbuilder","/com/rastersoft/dbuilder");

		// Loads this UI file
		this.builder.add_from_file(GLib.Path.build_filename(Constants.PKGDATADIR,"iface_test.ui"));
		// And now requests to the remote Gtk.Builder to send the "clicked" signals generated,
		// as defined in Glade
		this.builder.connect_signals();
		// We could use "connect_signal" to manually connect signals and widgets to methods, like:
		//this.builder.connect_signal("clicked","button","client_on_button_clicked");
		//this.builder.connect_signal("changed","entry1","client_on_entry1_changed");

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
