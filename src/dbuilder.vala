//using GIO;
using Gtk;
using GLib;
using Gee;

[DBus (name = "com.rastersoft.dbuildererror")]
public errordomain DBuildError
{
    ERROR_OBJECT, ERROR_FILE, ERROR_SIGNAL
}

   /*
    This class encapsulates a Gtk.Builder over DBus, allowing a remote program
    to load one or several UI files, get access to the properties of all the
    widgets (thanks to the capabilities of Gtk3), and receive the signals generated
    by them
    */

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

	/**
	 * Specifies the GLADE UI file to load in the Gtk.Builder class
	 * @param path The path to the UI file
	 */

	public void add_from_file(string path) throws Error {
		try {
			this.builder.add_from_file(path);
		} catch (Error e) {
			throw new DBuildError.ERROR_FILE(e.message);
		}
	}

	/**
	 * Allows to receive the signals generated by the widgets
	 * @param signal_name The signal to receive
	 * @param object The object from which we want to receive the signal
	 */
	public void connect_signal(string signal_name, string object) throws Error {

		GLib.Object ? element = this.builder.get_object(object);
		if (element == null) {
			throw new DBuildError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
		}

		/* We maintain a dictionary that maps the object pointer to the object name.
		   This is a must in order to be able to send to the client the name of the
		   object that generated the signal */
		if (!this.objects.has_key(element)) {
			this.objects.set(element,object);
		}

		/* Since a signal callback passes a pointer to the object that generated the
		   signal, we can share a callback with all the objects that can generate one
		   specific signal. Unfortunately, the callback doesn't specificate what signal
		   generated it, so we must have one callback for each signal name (this is: we
		   need one callback for the "clicked" signal, but it can serve an unlimited
		   number of buttons; also we need one different callback for the "changed"
		   signal, but it can serve an unlimited number of Gtk.Entry widgets)

		   We store the signal name in a list, along with the callback associated to
		   it. This allows to retrieve the signal name later, in the callback
		 */

		var f = this.callbacks.index_of(signal_name);
		if (f == -1) {
			this.callbacks.add(signal_name);
			f = this.callbacks.index_of(signal_name);
		}

		/* Now, we connect the signal to the callback associated with that specific signal name */
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

	/**
	 * This is the first callback for signals.
	 * Due to use g_signal_connect_object directly, the parameters are passed
	 * to the callback inverted, so "this" points to the object that sent the
	 * signal, and the parameter this2 points to the class.
	 */
	private void callback0(dbuilder this2) {

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

	/**
	 * The show, show_all and hide methods must be manually implemented, because
	 * they can't be managed with the GObject properties system
	 */

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

	/**
	    Here are the methods to get access to the public internal properties of
	    a widget. It takes advantage of the GObject properties system, that
	    allows to get access to the properties using a string with the property
	    name
	*/

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
