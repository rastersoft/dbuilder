/* The Vala syntactic sugar interferes when wanting to link a signal based on its name,
   so it is a must to define a direct access to the underlying C api with this VAPI file */

[CCode (cname = "g_signal_connect")]
int signal_connect(GLib.Object object, string signal_name, GLib.Callback handler, void * data);
