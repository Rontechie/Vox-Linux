import qs
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win
            required property var modelData
            screen: modelData

            readonly property HyprlandMonitor monitor: Hyprland.monitorFor(modelData)
            readonly property bool fullscreenHere: HyprlandData.workspaceById[monitor?.activeWorkspace?.id]?.hasfullscreen ?? false
            readonly property int mode: Config.options.appearance.fakeScreenRounding
            readonly property real size: Appearance.rounding.screenRounding

            visible: mode === 1 || (mode === 2 && !fullscreenHere)

            WlrLayershell.namespace: "quickshell:screenCorners"
            WlrLayershell.layer: WlrLayer.Overlay
            exclusionMode: ExclusionMode.Ignore
            color: "transparent"
            mask: Region { item: null } // clicks go straight through

            anchors {
                top: true
                left: true
                right: true
                bottom: true
            }

            RoundCorner {
                anchors.top: parent.top
                anchors.left: parent.left
                implicitSize: win.size
                corner: RoundCorner.CornerEnum.TopLeft
            }
            RoundCorner {
                anchors.top: parent.top
                anchors.right: parent.right
                implicitSize: win.size
                corner: RoundCorner.CornerEnum.TopRight
            }
            RoundCorner {
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                implicitSize: win.size
                corner: RoundCorner.CornerEnum.BottomLeft
            }
            RoundCorner {
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                implicitSize: win.size
                corner: RoundCorner.CornerEnum.BottomRight
            }
        }
    }
}
