//using GIO;
using Gtk;
using GLib;
using Gee;

[DBus (name = "com.rastersoft.dbuildererror")]
public errordomain DBuildError
{
    ERROR_OBJECT, ERROR_FILE, ERROR_SIGNAL
}

[DBus(name = "com.rastersoft.dbuilder")]
public class dbuilder : GLib.Object {

	private Gtk.Builder builder;
	private Gee.List<string> callbacks;
	private Gee.Map<GLib.Object,string> objects;

	public signal void sent_event(string obj, string event);

	public dbuilder(Gtk.Builder builder) {
		this.builder = builder;
		this.callbacks = new Gee.ArrayList<string>();
		this.objects = new Gee.HashMap<GLib.Object,string>();
	}

	public void add_from_file(string path) throws Error {
		try {
			this.builder.add_from_file(path);
		} catch (Error e) {
			throw new DBuildError.ERROR_FILE(e.message);
		}
	}

	public void connect_signal(string signal_name, string object) throws Error {

		GLib.Object ? element = this.builder.get_object(object);
		if (element == null) {
			throw new DBuildError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
		}

		if (!this.objects.has_key(element)) {
			this.objects.set(element,object);
		}

		var f = this.callbacks.index_of(signal_name);
		if (f == -1) {
			this.callbacks.add(signal_name);
			f = this.callbacks.index_of(signal_name);
		}

		switch (f) {
		case 0:
			signal_connect(element,signal_name,(GLib.Callback)this.callback0,this,0);
		break;
		case 1:
			signal_connect(element,signal_name,(GLib.Callback)this.callback1,this,0);
		break;
		case 2:
			signal_connect(element,signal_name,(GLib.Callback)this.callback2,this,0);
		break;
		default:
			throw new DBuildError.ERROR_SIGNAL("The signal %s can't be connected. Too many signals.".printf(signal_name));
		}
	}

	private void callback0(dbuilder this2) {

		/* Due to use g_signal_connect_object directly, the parameters are passed to the callback inverted, so "this" points to the
		   object that sent the signal, and the parameter points to this class */
		if (this2.objects.has_key(this)) {
			this2.sent_event(this2.objects.get(this),this2.callbacks[0]);
		}
	}

	private void callback1(dbuilder this2) {

		if (this2.objects.has_key(this)) {
			this2.sent_event(this2.objects.get(this),this2.callbacks[1]);
		}
	}

	private void callback2(dbuilder this2) {
		if (this2.objects.has_key(this)) {
			this2.sent_event(this2.objects.get(this),this2.callbacks[2]);
		}
	}

	public void show_widget(string object) throws Error {

		Gtk.Widget ? element = (Gtk.Widget) this.builder.get_object(object);
		if (element == null) {
			throw new DBuildError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
		}
		element.show();
	}

	public void show_all_widget(string object) throws Error {

		Gtk.Widget ? element = (Gtk.Widget) this.builder.get_object(object);
		if (element == null) {
			throw new DBuildError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
		}
		element.show_all();
	}

	public void hide_widget(string object) throws Error {

		Gtk.Widget ? element = (Gtk.Widget) this.builder.get_object(object);
		if (element == null) {
			throw new DBuildError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
		}
		element.hide();
	}

	public string get_string(string object, string property) throws Error {

		GLib.Object ? element = this.builder.get_object(object);
		if (element == null) {
			throw new DBuildError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
		}
		GLib.Value val = GLib.Value(typeof(string));
		element.get_property(property, ref val);
		return val.get_string();
	}

	public void set_string(string object, string property, string val) throws Error {
		GLib.Object ? element = this.builder.get_object(object);
		if (element == null) {
			throw new DBuildError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
		}
		GLib.Value val2 = GLib.Value(typeof(string));
		val2.set_string(val);
		element.set_property(property,val2);
	}

	public int get_integer(string object, string property) throws Error {
		GLib.Object ? element = this.builder.get_object(object);
		if (element == null) {
			throw new DBuildError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
		}
		GLib.Value val = GLib.Value(typeof(int));
		element.get_property(property, ref val);
		return val.get_int();
	}

	public void set_integer(string object, string property, int val) throws Error {
		GLib.Object ? element = this.builder.get_object(object);
		if (element == null) {
			throw new DBuildError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
		}
		GLib.Value val2 = GLib.Value(typeof(int));
		val2.set_int(val);
		element.set_property(property,val2);
	}

	public bool get_bool(string object, string property) throws Error {
		GLib.Object ? element = this.builder.get_object(object);
		if (element == null) {
			throw new DBuildError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
		}
		GLib.Value val = GLib.Value(typeof(bool));
		element.get_property(property, ref val);
		return val.get_boolean();
	}

	public void set_bool(string object, string property, bool val) throws Error {
		GLib.Object ? element = this.builder.get_object(object);
		if (element == null) {
			throw new DBuildError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
		}
		GLib.Value val2 = GLib.Value(typeof(bool));
		val2.set_boolean(val);
		element.set_property(property,val2);
	}

	public double get_double(string object, string property) throws Error {
		GLib.Object ? element = this.builder.get_object(object);
		if (element == null) {
			throw new DBuildError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
		}
		GLib.Value val = GLib.Value(typeof(double));
		element.get_property(property, ref val);
		return val.get_double();
	}

	public void set_double(string object, string property, double val) throws Error {
		GLib.Object ? element = this.builder.get_object(object);
		if (element == null) {
			throw new DBuildError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
		}
		GLib.Value val2 = GLib.Value(typeof(double));
		val2.set_double(val);
		element.set_property(property,val2);
	}
}
