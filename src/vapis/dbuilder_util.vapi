[CCode (cname = "g_signal_connect")]
int signal_connect(GLib.Object object, string signal_name, GLib.Callback handler, void * data);
