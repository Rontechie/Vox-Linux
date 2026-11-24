import qs
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import Quickshell
import qs.modules.desktopWidgets.ui

Item {
    id: root
    anchors.fill: parent

    property bool open: false
    property real menuX: 0
    property real menuY: 0

    function show(x: real, y: real): void {
        menuX = Math.max(8, Math.min(width - bar.width - 8, x - bar.width / 2));
        menuY = Math.max(8, Math.min(height - bar.height - 8, y + 8));
        open = true;
        hideTimer.restart();
    }
    function hide(): void { open = false; }

    MouseArea {
        anchors.fill: parent
        enabled: root.open
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onPressed: mouse => {
            if (mouse.button === Qt.RightButton) root.show(mouse.x, mouse.y);
            else root.hide();
        }
    }

    Timer {
        id: hideTimer
        interval: 6000
        onTriggered: if (!hover.hovered) root.hide(); else restart()
    }

    StyledRectangularShadow { target: bar; visible: bar.visible }

    Rectangle {
        id: bar
        x: root.menuX
        y: root.menuY
        visible: opacity > 0
        opacity: root.open ? 1 : 0
        scale: root.open ? 1 : 0.85
        transformOrigin: Item.Top
        Behavior on opacity { NumberAnimation { duration: 140 } }
        Behavior on scale { NumberAnimation { duration: 180; easing.type: Easing.OutBack } }
        implicitWidth: row.implicitWidth + 16
        implicitHeight: 62
        radius: 18
        color: Appearance.colors.colLayer1
        border.width: 1
        border.color: Appearance.colors.colOutlineVariant

        HoverHandler { id: hover }

        Row {
            id: row
            anchors.centerIn: parent
            spacing: 6
            Repeater {
                model: [
                    { icon: "wallpaper", act: "wallpaper" },
                    { icon: "widgets", act: "widgets" },
                    { icon: "lock", act: "lock" }
                ]
                delegate: Rectangle {
                    id: btn
                    required property var modelData
                    width: 56
                    height: 46
                    radius: height / 2          // capsule
                    scale: area.pressed ? 0.94 : 1
                    Behavior on scale { NumberAnimation { duration: 100 } }
                    color: area.containsMouse ? Appearance.colors.colPrimaryContainer : Appearance.colors.colLayer2
                                        Behavior on color { ColorAnimation { duration: 120 } }
                    MaterialSymbol {
                        anchors.centerIn: parent
                        text: btn.modelData.icon
                        iconSize: 22
                        fill: area.containsMouse ? 1 : 0
                        color: area.containsMouse ? Appearance.colors.colOnPrimaryContainer : Appearance.colors.colOnLayer2
                    }
                    MouseArea {
                        id: area
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.hide();
                            if (btn.modelData.act === "wallpaper")
                                GlobalStates.wallpaperSelectorOpen = true;
                            else if (btn.modelData.act === "widgets")
                                HwConfig.editMode = true;     // widget edit mode: gallery, drag, resize
                            else
                                Quickshell.execDetached(["qs", "-p", Quickshell.shellPath("shell.qml"), "ipc", "call", "lock", "activate"]);
                        }
                    }
                }
            }
        }
    }
}
