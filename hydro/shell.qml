
import QtQuick
import Quickshell
import qs.modules.common
import qs.services

import qs.modules.bar
import qs.modules.notificationPopup
import qs.modules.onScreenDisplay
import qs.modules.overview
import qs.modules.dashboard
import qs.modules.launcher
import qs.modules.background
import qs.modules.dock
import qs.modules.polkit
import qs.modules.lock
import qs.modules.wallpaperSelector
import qs.modules.screenCorners

ShellRoot {
    Component.onCompleted: {
        MaterialThemeLoader.reapplyTheme()
        ConflictKiller.load()   // stops other notification daemons (mako, dunst...) so ours can own the bus
        Cliphist.refresh()      // clipboard history for the overview search
    }

    component PanelLoader: LazyLoader {
        property bool extraCondition: true
        active: Config.ready && extraCondition
    }

    PanelLoader { component: Background {} }
    PanelLoader { component: Bar {} }  // bar.vertical needs VerticalBar, not ported yet
    PanelLoader { component: NotificationPopup {} }
    PanelLoader { component: OnScreenDisplay {} }
    PanelLoader { component: Overview {} }
    PanelLoader { component: Dashboard {} }
    PanelLoader { component: Launcher {} }
    PanelLoader { component: Dock {} }
    PanelLoader { component: Polkit {} }  // Hydro's polkit authentication agent
    PanelLoader { component: Lock {} }    // Hydro lock screen (qs ipc call lock activate)
    PanelLoader { component: ScreenCorners {} }       // rounded screen corners (appearance.fakeScreenRounding)
    PanelLoader { component: WallpaperSelector {} }   // qs ipc call wallpaperSelector toggle / right-click menu
}
