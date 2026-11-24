import qs
import qs.services
import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root
    property int dashWidth: Appearance.sizes.sidebarWidth

    PanelWindow {
        id: panelWindow
        readonly property bool open: GlobalStates.sidebarRightOpen
        visible: open || slider.x < panelWindow.width - 1

        function hide() {
            GlobalStates.sidebarRightOpen = false;
        }

        exclusiveZone: 0
        implicitWidth: root.dashWidth
        WlrLayershell.namespace: "quickshell:sidebarRight"
        WlrLayershell.keyboardFocus: GlobalStates.sidebarRightOpen ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
        color: "transparent"

        anchors {
            top: true
            right: true
            bottom: true
        }

        onOpenChanged: {
            if (open) GlobalFocusGrab.addDismissable(panelWindow);
            else GlobalFocusGrab.removeDismissable(panelWindow);
        }
        Connections {
            target: GlobalFocusGrab
            function onDismissed() {
                panelWindow.hide();
            }
        }

        Item { // slides in from the right edge and back out again
            id: slider
            width: panelWindow.width
            height: panelWindow.height
            x: panelWindow.open ? 0 : panelWindow.width
            Behavior on x { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }

            Loader {
                active: panelWindow.open || Config?.options.sidebar.keepRightSidebarLoaded || slider.x < panelWindow.width - 1
                anchors {
                    fill: parent
                    margins: Appearance.sizes.hyprlandGapsOut
                    leftMargin: Appearance.sizes.elevationMargin
                }
                focus: panelWindow.open
                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) panelWindow.hide();
                }
                sourceComponent: DashboardContent {}
            }
        }
    }

    IpcHandler {
        target: "sidebarRight"
        function toggle(): void { GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen; }
        function close(): void { GlobalStates.sidebarRightOpen = false; }
        function open(): void { GlobalStates.sidebarRightOpen = true; }
    }
    IpcHandler {
        target: "dashboard"
        function toggle(): void { GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen; }
    }

    GlobalShortcut {
        name: "sidebarRightToggle"
        description: "Toggles dashboard on press"
        onPressed: GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen
    }
    GlobalShortcut {
        name: "sidebarRightOpen"
        description: "Opens dashboard on press"
        onPressed: GlobalStates.sidebarRightOpen = true
    }
    GlobalShortcut {
        name: "sidebarRightClose"
        description: "Closes dashboard on press"
        onPressed: GlobalStates.sidebarRightOpen = false
    }
}
