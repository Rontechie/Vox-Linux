
import QtQuick
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.nexus
import qs.modules.nexus.compat
import qs.modules.nexus.services
import qs.modules.polkit

ShellRoot {
    Polkit {}

    Component.onCompleted: {
        MaterialThemeLoader.reapplyTheme();
    }

    Timer {
        interval: 250
        running: true
        onTriggered: Quickshell.execDetached(["sh", "-c", "command -v hyprctl >/dev/null 2>&1 && hyprctl --batch 'dispatch setfloating ; dispatch centerwindow'"])
    }

    FloatingWindow {
        id: win

        visible: true
        color: Colours.tPalette.m3surface

        width: 1257
        height: 764
        minimumSize.width: 1257
        minimumSize.height: 764

        title: "Nexus"

        Nexus {
            id: nexus

            anchors.fill: parent
            nState.screen: win.screen
            nState.isWindow: true
            onClose: Qt.quit()
        }
    }
}
