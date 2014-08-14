## DBuilder ##

This is a library that allows to embed Gtk interfaces in remote processes using
DBus. The idea is that, in order to export an interface using DBus, you need to
be able to:

  * create a graphical interface with any kind of widgets in the remote side
  * get access to a widget in the remote side using a string identifier instead of pointers to objects
  * get access to the public properties in any widget in the remote side using string identifiers instead of local methods
  * get notified when a remote widget generates a signal that has interest to us

The interesting thing about this is that Gtk3 itself has nearly all the mechanisms needed
to do this, and only some little glue code is needed to make it work.

First, by using Gtk.Builder it is possible to create a GUI from a textual definition,
without needing to manually create objects and insert some inside others. This textual
definition can be a string or the path for a file with that definition; both can be
sent through DBus.

Also, to access these widgets it is possible to use a textual description (the widget
name) contained in an string, which also can be sent natively through DBus.

Nearly all the useful data in the most common widgets are contained in public
properties. Thanks to the properties system available in Gtk3, it is possible to
refer to a property using a string with its name, instead of using specific
methods. Again, those strings can be sent through DBus.

Finally, when setting a callback for a signal, the signal name is specified using
a text string, so this also allows to create a DBus remote method that links a signal
in a widget with an specific callback, which sends the signal name and the widget name
to the client side using a DBus callback.


## Sample code ##

This GIT repository contains a proof of concept for this. To compile this, you
need Vala 20.0 or later, cmake and Gtk3. Just do:

	mkdir install
	cd install
	cmake ..
	make
	sudo make install

After doing this, just run from a terminal 'dbuilder_server', and from another terminal
'dbuilder_client', in this precise order. As soon as you run the client, two windows
will be shown in the screen. One is created by the server, and the other by the client,
but both are managed by the client using DBus. There is nothing specific for this demo
in the server side, and any glade-generated UI file can be loaded by the client and
controlled.

By writing in both text entries or clicking in the button you can see how easy is
to interact with a remote GUI.


## About the author ##

This proof of concept has been created by:

Sergio Costas Rodriguez (raster@rastersoft.com)
http://www.rastersoft.com
https://github.com/rastersoft
