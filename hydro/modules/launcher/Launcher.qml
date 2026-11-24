import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root

    LauncherCore {
        id: core
    }

    SearchLauncher {
        core: core
    }

    PanelWindow {
        id: win
        readonly property bool open: GlobalStates.launcherOpen && Config.options.launcher.style !== "search"
        readonly property real pad: Appearance.sizes.elevationMargin + Appearance.sizes.hyprlandGapsOut

        visible: open
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        implicitWidth: core.cardW + pad * 2
        implicitHeight: core.cardH + pad * 2
        WlrLayershell.namespace: "quickshell:launcher"
        WlrLayershell.keyboardFocus: open ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None

        anchors {
            left: true
            top: !Config.options.bar.bottom
            bottom: Config.options.bar.bottom
        }

        readonly property real barClearance: Math.max(0, (Config.options.bar.autoHide.enable ? 0 : Appearance.sizes.barHeight) + Config.options.launcher.gap - pad)
        margins {
            top: Config.options.bar.bottom ? 0 : barClearance
            bottom: Config.options.bar.bottom ? barClearance : 0
        }

        onOpenChanged: {
            if (open) {
                grabDelay.restart();
                Qt.callLater(() => { if (cardLoader.item) cardLoader.item.focusSearch() });
            } else {
                grabDelay.stop();
                win.armed = false;
                GlobalFocusGrab.removeDismissable(win);
                core.settingsOpen = false;
            }
        }
        Timer {
            id: grabDelay
            interval: 200
            onTriggered: {
                if (win.open) {
                    win.armed = true;
                    GlobalFocusGrab.addDismissable(win);
                }
            }
        }
        property bool armed: false
        Connections {
            target: GlobalFocusGrab
            function onDismissed() {
                if (win.armed)
                    core.closeAll();
            }
        }

        StyledRectangularShadow {
            target: cardHolder
            visible: win.open
        }
        Item {
            id: cardHolder
            property real radius: 36 // for the shadow
            anchors {
                fill: parent
                margins: win.pad
            }
            Loader {
                id: cardLoader
                anchors.fill: parent
                active: win.open
                focus: win.open
                sourceComponent: LauncherCard {
                    host: core
                }
            }
        }
    }

    IpcHandler {
        target: "launcher"
        function toggle(): void { GlobalStates.launcherOpen = !GlobalStates.launcherOpen; }
        function open(): void { GlobalStates.launcherOpen = true; }
        function close(): void { GlobalStates.launcherOpen = false; }
    }

    GlobalShortcut {
        name: "launcherToggle"
        description: "Toggles the launcher"
        onPressed: GlobalStates.launcherOpen = !GlobalStates.launcherOpen
    }
}
