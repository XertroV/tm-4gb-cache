const string PLUGIN_NAME = Meta::ExecutingPlugin().Name;
const string PLUGIN_ICON = "";

void Main() {
    if (CheckOnLoadOkay()) {
        UpdateCacheLimitFromSettings();
    } else {
        NotifyWarning("Checking initial cache limit: it is not as expected, so cache limit will not automatically be set.\n\nIf the game has recently updated, it is likely this plugin needs to be updated, too.");
    }
}

void NotifyError(const string &in msg) {
    warn(msg);
    UI::ShowNotification(Meta::ExecutingPlugin().Name + ": Error", msg, vec4(.9, .3, .1, .3), 15000);
}

void NotifyWarning(const string &in msg) {
    warn(msg);
    UI::ShowNotification(Meta::ExecutingPlugin().Name + ": Warning", msg, vec4(.9, .6, .2, .3), 15000);
}
