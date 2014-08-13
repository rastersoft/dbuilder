//using GIO;
using Gtk;
using GLib;
using Gee;

[DBus (name = "com.rastersoft.dbuildererror")]
public errordomain DBuilderError
{
	ERROR_OBJECT, ERROR_FILE, ERROR_SIGNAL
}

namespace DBuilder {

	private class DBuilderCallback : GLib.Object {

		public string object;
		public string signal_name;
		public string callback;
		public GLib.Object ? element;
		public DBuilder dbuilder;

	}

	void global_callback(GLib.Object sender, DBuilderCallback cb) {

		cb.dbuilder.send_callback(cb);
	}

	   /*
		This class encapsulates a Gtk.Builder over DBus, allowing a remote program
		to load one or several UI files, get access to the properties of all the
		widgets (thanks to the capabilities of Gtk3), and receive the signals generated
		by them
		*/

	[DBus(name = "com.rastersoft.dbuilder")]
	public class DBuilder : GLib.Object {

		private Gtk.Builder builder;
		private Gee.List<string> callbacks;
		private Gee.Map<GLib.Object,string> objects;

		public signal void sent_event(string obj, string event);

		public DBuilder(Gtk.Builder builder) {
			this.builder = builder;
			this.callbacks = new Gee.ArrayList<string>();
			this.objects = new Gee.HashMap<GLib.Object,string>();
		}

		/**
		 * Specifies the GLADE UI file to load in the Gtk.Builder class
		 * @param path The path to the UI file
		 */

		public void add_from_file(string path) throws DBuilderError {
			try {
				this.builder.add_from_file(path);
			} catch (Error e) {
				throw new DBuilderError.ERROR_FILE(e.message);
			}
		}

		/**
		 * Allows to receive the signals generated by the widgets
		 * @param signal_name The signal to receive
		 * @param object The object from which we want to receive the signal
		 */
		public void connect_signal(string signal_name, string object) throws DBuilderError {

			GLib.Object ? element = this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}

			var callback_data = new DBuilderCallback();
			callback_data.object = object;
			callback_data.element = element;
			callback_data.signal_name = signal_name;
			callback_data.callback = "on_%s_%s".printf(object,signal_name);
			callback_data.dbuilder = this;
			callback_data.ref(); // this ensures that the object survives after exiting this method

			signal_connect(element,signal_name,(GLib.Callback) global_callback, callback_data);

		}

		[DBus(visible = false)]
		public void send_callback(GLib.Object obj) {
			DBuilderCallback cb = (DBuilderCallback) obj;
			this.sent_event(cb.object,cb.signal_name);
		}


		/**
		 * The show, show_all and hide methods must be manually implemented, because
		 * they can't be managed with the GObject properties system
		 */

		public void show_widget(string object) throws DBuilderError {

			Gtk.Widget ? element = (Gtk.Widget) this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			element.show();
		}

		public void show_all_widget(string object) throws DBuilderError {

			Gtk.Widget ? element = (Gtk.Widget) this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			element.show_all();
		}

		public void hide_widget(string object) throws DBuilderError {

			Gtk.Widget ? element = (Gtk.Widget) this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			element.hide();
		}

		/**
			Here are the methods to get access to the public internal properties of
			a widget. It takes advantage of the GObject properties system, that
			allows to get access to the properties using a string with the property
			name
		*/

		public string get_string(string object, string property) throws DBuilderError {

			GLib.Object ? element = this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			GLib.Value val = GLib.Value(typeof(string));
			element.get_property(property, ref val);
			return val.get_string();
		}

		public void set_string(string object, string property, string val) throws DBuilderError {
			GLib.Object ? element = this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			GLib.Value val2 = GLib.Value(typeof(string));
			val2.set_string(val);
			element.set_property(property,val2);
		}

		public int get_integer(string object, string property) throws DBuilderError {
			GLib.Object ? element = this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			GLib.Value val = GLib.Value(typeof(int));
			element.get_property(property, ref val);
			return val.get_int();
		}

		public void set_integer(string object, string property, int val) throws DBuilderError {
			GLib.Object ? element = this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			GLib.Value val2 = GLib.Value(typeof(int));
			val2.set_int(val);
			element.set_property(property,val2);
		}

		public bool get_bool(string object, string property) throws DBuilderError {
			GLib.Object ? element = this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			GLib.Value val = GLib.Value(typeof(bool));
			element.get_property(property, ref val);
			return val.get_boolean();
		}

		public void set_bool(string object, string property, bool val) throws DBuilderError {
			GLib.Object ? element = this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			GLib.Value val2 = GLib.Value(typeof(bool));
			val2.set_boolean(val);
			element.set_property(property,val2);
		}

		public double get_double(string object, string property) throws DBuilderError {
			GLib.Object ? element = this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			GLib.Value val = GLib.Value(typeof(double));
			element.get_property(property, ref val);
			return val.get_double();
		}

		public void set_double(string object, string property, double val) throws DBuilderError {
			GLib.Object ? element = this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			GLib.Value val2 = GLib.Value(typeof(double));
			val2.set_double(val);
			element.set_property(property,val2);
		}
	}
}
