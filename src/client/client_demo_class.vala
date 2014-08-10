//using GIO;
using Gtk;
using GLib;
using Gee;

[DBus(name = "com.rastersoft.dbuilder")]
interface dbuilder : GLib.Object {

	public signal void sent_event(string obj, string event);

	public abstract void add_from_file(string path) throws Error;
	public abstract void connect_signal(string signal_name, string object) throws Error;

	public abstract void show_widget(string object) throws Error;
	public abstract void show_all_widget(string object) throws Error;
	public abstract void hide_widget(string object) throws Error;

	public abstract string get_string(string object, string property) throws Error;
	public abstract void set_string(string object, string property, string val) throws Error;
	public abstract int get_integer(string object, string property) throws Error;
	public abstract void set_integer(string object, string property, int val) throws Error;
	public abstract bool get_bool(string object, string property) throws Error;
	public abstract void set_bool(string object, string property, bool val) throws Error;
	public abstract double get_double(string object, string property) throws Error;
	public abstract void set_double(string object, string property, double val) throws Error;
}

public class client : Object {

	private dbuilder builder;
	private Gtk.Builder builder2;

	private void remote_event(string obj, string event) {

		GLib.stdout.printf("Received event %s from object %s\n", event, obj);

		if ((obj == "button") && (event == "clicked")) {
			var w = (Gtk.Label)this.builder2.get_object("label1");
			w.set_text("Button clicked");
			return;
		}

		if ((obj == "entry1") && (event == "changed")) {
			var w = (Gtk.Label)this.builder2.get_object("label2");
			w.set_text(this.builder.get_string("entry1","text"));
			return;
		}
	}

	private void changed_entry() {

		var w = (Gtk.Entry)this.builder2.get_object("entry1");
		this.builder.set_string("label","label",w.get_text());

	}

	public client(string[] argv) {
	
		Gtk.init(ref argv);

		this.builder2 = new Gtk.Builder();
		this.builder2.add_from_file(GLib.Path.build_filename(Constants.PKGDATADIR,"iface_test2.ui"));
		var w = (Gtk.Window)this.builder2.get_object("window1");
		w.show_all();
		var w2 = (Gtk.Entry)this.builder2.get_object("entry1");
		w2.changed.connect(this.changed_entry);

		try {
			this.builder = Bus.get_proxy_sync (BusType.SESSION, "com.rastersoft.dbuilder","/com/rastersoft/dbuilder");
		} catch (Error e) {
			GLib.stderr.printf("Error when connecting to the server: %s",e.message);
		}
		this.builder.add_from_file(GLib.Path.build_filename(Constants.PKGDATADIR,"iface_test.ui"));
		this.builder.sent_event.connect(this.remote_event);
		this.builder.connect_signal("clicked","button");
		this.builder.connect_signal("changed","entry1");
		this.builder.show_all_widget("window1");
	}

	public void run() {
		Gtk.main();
	}

}
