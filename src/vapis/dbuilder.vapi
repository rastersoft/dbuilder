[CCode (cname = "g_signal_connect_object")]
int signal_connect(GLib.Object object, string signal_name, GLib.Callback handler, void * data, int flags);
