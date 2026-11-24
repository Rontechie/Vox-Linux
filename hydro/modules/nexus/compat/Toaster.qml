pragma Singleton

import Quickshell

Singleton {
    function toast(title: string, message: string, icon: string): void {
        Quickshell.execDetached(["notify-send", "-a", "Hydro", title, message]);
    }
}
