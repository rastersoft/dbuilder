//using GIO;
using Gtk;
using GLib;
using Gee;

int main(string[] argv) {

	var c = new client(argv);
	c.run();
	return 0;
}
