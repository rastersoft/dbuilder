//using GIO;
//using GModule;
using Gtk;
using GLib;
using Gee;

[DBus (name = "com.rastersoft.dbuildererror")]
public errordomain DBuilderError
{
	ERROR_OBJECT, ERROR_FILE, ERROR_SIGNAL
}
private delegate void DBuilder_main_callback(GLib.Object this,string obj);

namespace DBuilder {

	/**
	 * This is the interface to allow the client to get access to the remote
	 * DBuilderServer class.
	 *
	 * It contains several methods that allows to get access to the Gtk.Builder
	 * contained in the remote DBuilderServer object.
	 */
	[DBus(name = "com.rastersoft.dbuilder")]
	public interface DBuilder : GLib.Object {

		public signal void sent_event(string obj, string event, string callback_name);

		/**
		 * Parses a file containing a GtkBuilder UI definition and merges it with the current contents of the exported Gtk.Builder
		 * @param path The path to the file to parse
		 */
		public abstract void add_from_file(string path) throws Error;

		/**
		 * Parses a file containing a GtkBuilder UI definition building only the requested objects and merges them with the current contents of the exported Gtk.Builder
		 * @param path The path to the file to parse
		 * @param object_ids A list of objects to build (it will also build its childs)
		 */
		public abstract void add_objects_from_file(string path, string[] object_ids) throws Error;

		/**
		 * Parses a resource file containing a GtkBuilder UI definition and merges it with the current contents of the exported Gtk.Builder
		 * @param path The path to the resource file to parse
		 */
		public abstract void add_from_resource(string path) throws Error;

		/**
		 * Parses a resource file containing a GtkBuilder UI definition building only the requested objects and merges them with the current contents of the exported Gtk.Builder
		 * @param path The path to the resource file to parse
		 * @param object_ids A list of objects to build (it will also build its childs)
		 */
		public abstract void add_objects_from_resource(string path, string[] object_ids) throws Error;

		/**
		 * Parses a string containing a GtkBuilder UI definition and merges it with the current contents of the exported Gtk.Builder
		 * @param data The string with the data to parse
		 */
		public abstract void add_from_string(string data) throws Error;

		/**
		 * Parses a string containing a GtkBuilder UI definition building only the requested objects and merges them with the current contents of the exported Gtk.Builder
		 * @param data The string with the data to parse
		 * @param object_ids A list of objects to build (it will also build its childs)
		 */
		public abstract void add_objects_from_string(string data, string[] object_ids) throws Error;

		/**
		 * Allows to listen to the signal //signal_name//, generated by //object//, by calling to the function //callback//.
		 * @param signal_name The name of the signal to listen to
		 * @param object The name of the object that must generate the signal
		 * @param callback The name of the function/method to call. It must be in C format (this is: namespace_class_methodname), like in Glade
		 */
		public abstract void connect_signal(string signal_name, string object, string callback) throws Error;

		/**
		 * Allows to automatically connect the signals defined in the original UI file
		 */
		public abstract void connect_signals() throws Error;

		/**
		 * Calls to the //show// method in a remote widget
		 * @param object The name of the object
		 */
		public abstract void show_widget(string object) throws Error;

		/**
		 * Calls to the //show_all// method in a remote widget
		 * @param object The name of the object
		 */
		public abstract void show_all_widget(string object) throws Error;

		/**
		 * Calls to the //hide// method in a remote widget
		 * @param object The name of the object
		 */
		public abstract void hide_widget(string object) throws Error;

		/**
		 * Gets the value of a //string// property in a remote widget
		 * @param object The object name
		 * @param property The property name
		 * @return The value contained in the property
		 */
		public abstract string get_string(string object, string property) throws Error;

		/**
		 * Sets the value of a //string// property in a remote widget
		 * @param object The object name
		 * @param property The property name
		 * @param val The new value
		 */
		public abstract void set_string(string object, string property, string val) throws Error;

		/**
		 * Gets the value of an //integer// property in a remote widget
		 * @param object The object name
		 * @param property The property name
		 * @return The value contained in the property
		 */
		public abstract int get_integer(string object, string property) throws Error;

		/**
		 * Sets the value of an //integer// property in a remote widget
		 * @param object The object name
		 * @param property The property name
		 * @param val The new value
		 */
		public abstract void set_integer(string object, string property, int val) throws Error;

		/**
		 * Gets the value of a //boolean// property in a remote widget
		 * @param object The object name
		 * @param property The property name
		 * @return The value contained in the property
		 */
		public abstract bool get_bool(string object, string property) throws Error;

		/**
		 * Sets the value of a //boolean// property in a remote widget
		 * @param object The object name
		 * @param property The property name
		 * @param val The new value
		 */
		public abstract void set_bool(string object, string property, bool val) throws Error;

		/**
		 * Gets the value of a //float// property in a remote widget
		 * @param object The object name
		 * @param property The property name
		 * @return The value contained in the property. DBus doesn't support //float//, so the value is passed as a double
		 */
		public abstract double get_float(string object, string property) throws Error;

		/**
		 * Sets the value of a //float// property in a remote widget
		 * @param object The object name
		 * @param property The property name
		 * @param val The new value. DBus doesn't support //float//, so the value is passed as a double
		 */
		public abstract void set_float(string object, string property, double val) throws Error;

		/**
		 * Gets the value of a //double// property in a remote widget
		 * @param object The object name
		 * @param property The property name
		 * @return The value contained in the property
		 */
		public abstract double get_double(string object, string property) throws Error;

		/**
		 * Sets the value of a //double// property in a remote widget
		 * @param object The object name
		 * @param property The property name
		 * @param val The new value
		 */
		public abstract void set_double(string object, string property, double val) throws Error;
	}

	/**
	 * This class is used to create a client.
	 *
	 * It can be used to create a class that inherits from it, or can be instantiated.
	 */
	public class DBuilderClient : GLib.Object {

		private GLib.Module module = null;

		/**
		 * This method creates a proxy object that implements the DBuilder interface,
		 * allowing to interactuate with the remote Gtk.Builder object.
		 * @param dbus_server The server name where the remote DBuilderServer object resides
		 * @param dbus_object The object name of the remote DBuilderServer object
		 * @return A proxy object that implements the DBuilder interface, or //null// if there is an error
		 */
		public DBuilder? create_client (string dbus_server, string dbus_object)	 {

			if (this.module == null) {
				this.module = GLib.Module.open(null,0);
			}

			if (this.module == null) {
				return null;
			}

			try {
				DBuilder builder = Bus.get_proxy_sync<DBuilder> (BusType.SESSION, dbus_server, dbus_object);
				builder.sent_event.connect(this.remote_event);
				return builder;
			} catch (Error e) {
				return null;
			}
		}

		/**
		 * This callback receives the events produced by the remote widgets
		 * and calls the corresponding function callback
		 * @param obj The name of the remote Gtk.Widget that generated the event
		 * @param event The event name
		 * @param callback_name The function name for this callback
		 */

		public void remote_event(string obj, string event, string callback_name) {

			GLib.stdout.printf("Received event %s from object %s, for callback %s\n", event, obj, callback_name);
			if (this.module != null) {
				void *my_symbol;
				if (this.module.symbol(callback_name, out my_symbol)) {
					((DBuilder_main_callback)my_symbol)(this,obj);
				} else {
					GLib.stdout.printf("Callback %s not found\n",callback_name);
				}
			} else {
				GLib.stdout.printf("Can't get access to the \n");
			}
		}
	}

	/**
	 * This compact class is used to pass all the needed data to the signal's callback.
	 * It allows to retrieve the object, signal and callback names in string format,
	 * and also the original DBuilderServer object that manages that signal.
	 */
	[Compact]
	public class DBuilderCallback {

		public string object;
		public string signal_name;
		public string callback;
		public GLib.Object ? element;
		public DBuilderServer dbuilder;
	}

	void global_callback(GLib.Object sender, DBuilderCallback cb) {

		cb.dbuilder.send_callback(cb);
	}


	/**
	 * This class encapsulates a Gtk.Builder over DBus, allowing a remote program
	 * to load one or several UI files, get access to the properties of all the
	 * widgets (thanks to the capabilities of Gtk3), and receive the signals generated
	 * by them.
	 */
	[DBus(name = "com.rastersoft.dbuilder")]
	public class DBuilderServer : GLib.Object {

		private Gtk.Builder builder;

		/**
		 * Creates a new DBuilderServer and exports the specified Gtk.Builder object.
		 * @param builder A Gtk.Builder object that will be exported over DBus
		 */
		public DBuilderServer(Gtk.Builder builder) {
			this.builder = builder;
		}

		/**
		 * This signal is sent over DBus whenever a widget emits a registered signal.
		 * @param obj The name of the object that generated the signal
		 * @param event The name of the generated event
		 * @param callback_name The C name of the callback to be called in the client side
		 */
		public signal void sent_event(string obj, string event, string callback_name);


		/**
		 * Parses a file containing a GtkBuilder UI definition and merges it with the current contents of the exported Gtk.Builder
		 * @param path The path to the file to parse
		 */
		public void add_from_file(string path) throws DBuilderError {
			try {
				this.builder.add_from_file(path);
			} catch (Error e) {
				throw new DBuilderError.ERROR_FILE(e.message);
			}
		}

		/**
		 * Parses a file containing a GtkBuilder UI definition building only the requested objects and merges them with the current contents of the exported Gtk.Builder
		 * @param path The path to the file to parse
		 * @param object_ids A list of objects to build (it will also build its childs)
		 */
		public void add_objects_from_file(string path, string[] object_ids) throws DBuilderError {
			try {
				this.builder.add_objects_from_file(path, object_ids);
			} catch (Error e) {
				throw new DBuilderError.ERROR_FILE(e.message);
			}
		}

		/**
		 * Parses a resource file containing a GtkBuilder UI definition and merges it with the current contents of the exported Gtk.Builder
		 * @param path The path to the resource file to parse
		 */
		public void add_from_resource(string path) throws DBuilderError {
			try {
				this.builder.add_from_resource(path);
			} catch (Error e) {
				throw new DBuilderError.ERROR_FILE(e.message);
			}
		}

		/**
		 * Parses a resource file containing a GtkBuilder UI definition building only the requested objects and merges them with the current contents of the exported Gtk.Builder
		 * @param path The path to the resource file to parse
		 * @param object_ids A list of objects to build (it will also build its childs)
		 */
		public void add_objects_from_resource(string path, string[] object_ids) throws DBuilderError {
			try {
				this.builder.add_objects_from_resource(path, object_ids);
			} catch (Error e) {
				throw new DBuilderError.ERROR_FILE(e.message);
			}
		}

		/**
		 * Parses a string containing a GtkBuilder UI definition and merges it with the current contents of the exported Gtk.Builder
		 * @param data The string with the data to parse
		 */
		public void add_from_string(string data) throws DBuilderError {
			try {
				this.builder.add_from_string(data,data.length);
			} catch (Error e) {
				throw new DBuilderError.ERROR_FILE(e.message);
			}
		}

		/**
		 * Parses a string containing a GtkBuilder UI definition building only the requested objects and merges them with the current contents of the exported Gtk.Builder
		 * @param data The string with the data to parse
		 * @param object_ids A list of objects to build (it will also build its childs)
		 */
		public void add_objects_from_string(string data, string[] object_ids) throws DBuilderError {
			try {
				this.builder.add_objects_from_string(data, data.length, object_ids);
			} catch (Error e) {
				throw new DBuilderError.ERROR_FILE(e.message);
			}
		}

		/**
		 * This method is used to implement the //connect_signals// method. It is called by //connect_signals_full// method in Gtk.Builder for each
		 * signal to connect.
		 * @param builder The Gtk.Builder object that contains the interface
		 * @param object A pointer to the object that will generate the signal
		 * @param signal_name The name of the signal to connect
		 * @param handler_name The name of the C function to use as callback
		 * @param connect_object The object to use as //this//
		 * @param flags Connection flags
		 */
		private void do_connection(Gtk.Builder builder, GLib.Object object, string signal_name, string handler_name, GLib.Object? connect_object, ConnectFlags flags) {

			var object_w = object as Gtk.Buildable;
			if (object_w != null) {
				this.connect_signal(signal_name,object_w.get_name(),handler_name);
			} else {
				print("The requested object is not a buildable object\n");
			}
		}

		/**
		 * Connects the signals defined in the Glade editor for each remote widget with their corresponding callback
		 */
		public void connect_signals() throws DBuilderError {

			this.builder.connect_signals_full(this.do_connection);
		}

		/**
		 * Allows to manually assign a callback to a signal emited by a remote widget
		 * @param signal_name The signal to receive
		 * @param object The object from which we want to receive the signal
		 */
		public void connect_signal(string signal_name, string object, string callback_name) throws DBuilderError {

			print("Conecting %s to object %s with callback %s\n".printf(signal_name,object, callback_name));

			var element = this.find_element(object);

			var callback_data = new DBuilderCallback();
			callback_data.object = object;
			callback_data.element = element;
			callback_data.signal_name = signal_name;
			callback_data.callback = callback_name;
			callback_data.dbuilder = this;
			//callback_data.ref(); // this ensures that the object survives after exiting this method

			signal_connect(element,signal_name,(GLib.Callback) global_callback, (owned)callback_data);

		}

		/**
		 * This is an internal method that receives an event data as sent by the C callback
		 * and sents it over DBus.
		 * @param cb The event data
		 */
		[DBus(visible = false)]
		public void send_callback(DBuilderCallback cb) {
			this.sent_event(cb.object,cb.signal_name,cb.callback);
		}


		/**
		 * The show method is manually implemented as a comodity
		 * @param object The widget name
		 */
		public void show_widget(string object) throws DBuilderError {

			Gtk.Widget ? element = (Gtk.Widget) this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			element.show();
		}

		/**
		 * The show method is manually implemented because it can't be reproduced
		 * by only using the Gtk3 properties system.
		 * @param object The widget name
		 */
		public void show_all_widget(string object) throws DBuilderError {

			Gtk.Widget ? element = (Gtk.Widget) this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			element.show_all();
		}

		/**
		 * The hide method is manually implemented as a comodity
		 * @param object The widget name
		 */
		public void hide_widget(string object) throws DBuilderError {

			Gtk.Widget ? element = (Gtk.Widget) this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			element.hide();
		}

		/**
		 *This method searchs a widget by name, and throws an exception if that widget doesn't exist
		 * @param object The widget name
		 */
		private GLib.Object ? find_element(string object) throws DBuilderError {
			GLib.Object ? element = this.builder.get_object(object);
			if (element == null) {
				throw new DBuilderError.ERROR_OBJECT("The object %s doesn't exists".printf(object));
			}
			return element;
		}

		/**
		 * Encapsulates the job of getting the value of a property in a widget, allowing to simplify the
		 * methods for getting those values
		 * @param object The object that has the property to get the value
		 * @param property The property to read
		 * @param type_val The type of the data contained in the property (specified with 'typeof(type)')
		 * @return A GLib.Value with the requested data
		*/
		private GLib.Value get_value(string object, string property, GLib.Type type_val) throws DBuilderError {

			GLib.Value val = GLib.Value(type_val);
			var element = this.find_element(object);
			element.get_property(property, ref val);
			return val;
		}

		/**
		 * Encapsulates part of the job of setting the value of a property in a widget
		 * @param object The object that has the property to get the value
		 * @param property The property to read
		 * @param val The value to store
		*/
		private void set_value(string object, string property,GLib.Value val) throws DBuilderError {
			var element = this.find_element(object);
			element.set_property(property,val);
		}

		public string get_string(string object, string property) throws DBuilderError {

			return (this.get_value(object, property, typeof(string))).get_string();
		}

		public void set_string(string object, string property, string val) throws DBuilderError {

			GLib.Value val2 = GLib.Value(typeof(string));
			val2.set_string(val);
			this.set_value(object,property,val2);
		}

		public int get_integer(string object, string property) throws DBuilderError {

			return (this.get_value(object, property, typeof(int))).get_int();
		}

		public void set_integer(string object, string property, int val) throws DBuilderError {

			GLib.Value val2 = GLib.Value(typeof(int));
			val2.set_int(val);
			this.set_value(object,property,val2);
		}

		public bool get_bool(string object, string property) throws DBuilderError {

			return (this.get_value(object, property, typeof(bool))).get_boolean();
		}

		public void set_bool(string object, string property, bool val) throws DBuilderError {

			GLib.Value val2 = GLib.Value(typeof(bool));
			val2.set_boolean(val);
			this.set_value(object,property,val2);
		}

		/**
		 * must use double because DBus/GVariant doesn't support float
		 */
		public double get_float(string object, string property) throws DBuilderError {

			return (this.get_value(object, property, typeof(float))).get_float();
		}

		/**
		 * must use double because DBus/GVariant doesn't support float
		 */
		public void set_float(string object, string property, double val) throws DBuilderError {

			GLib.Value val2 = GLib.Value(typeof(float));
			val2.set_float((float)val);
			this.set_value(object,property,val2);
		}

		public double get_double(string object, string property) throws DBuilderError {

			return (this.get_value(object, property, typeof(double))).get_double();
		}

		public void set_double(string object, string property, double val) throws DBuilderError {

			GLib.Value val2 = GLib.Value(typeof(double));
			val2.set_double(val);
			this.set_value(object,property,val2);
		}
	}
}
