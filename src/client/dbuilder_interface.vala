//using GIO;
using Gtk;
using GLib;
using Gee;

/* Vala interface to get access to the exported Gtk.Builder */

[DBus(name = "com.rastersoft.dbuilder")]
interface dbuilder : GLib.Object {

	public signal void sent_event(string obj, string event, string callback_name);

	public abstract void add_from_file(string path) throws Error;
	public abstract void connect_signal(string signal_name, string object, string callback) throws Error;
	public abstract void connect_signals() throws Error;

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

