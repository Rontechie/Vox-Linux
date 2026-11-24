pragma ComponentBehavior: Bound

import qs
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Scope {
    id: root

    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: win

            required property ShellScreen modelData
            screen: modelData

            readonly property real iconSize: Math.max(32, Config.options.dock.height - 22)
            readonly property real notchRadius: 22
            readonly property int shownHeight: Math.round(Config.options.dock.height)
            readonly property int restHeight: 12
            property bool pinnedOpen: Config.options.dock.pinnedOnStartup
            property bool hovered: hoverArea.containsMouse
            readonly property bool emptyWorkspace: ToplevelManager.activeToplevel === null
            readonly property bool expanded: GlobalStates.screenLocked ? false
                : (pinnedOpen || hovered || (!Config.options.dock.hoverToReveal && emptyWorkspace))

            visible: Config.options.dock.enable && !GlobalStates.screenLocked
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: pinnedOpen ? shownHeight : 0
            WlrLayershell.namespace: "quickshell:dock"
            WlrLayershell.layer: WlrLayer.Top

            anchors {
                bottom: true
                left: true
                right: true
            }
            implicitHeight: shownHeight + 40

            mask: Region {
                item: hitBox
            }

            Item {
                id: hitBox
                width: notch.width
                height: notch.height - win.notchRadius + Config.options.dock.hoverRegionHeight + 2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
            }

            MouseArea {
                id: hoverArea
                anchors.fill: hitBox
                hoverEnabled: true
                acceptedButtons: Qt.NoButton
            }

            Rectangle {
                id: notch

                readonly property real contentWidth: row.implicitWidth + 28
                width: win.expanded ? contentWidth : 96
                height: (win.expanded ? win.shownHeight : win.restHeight) + win.notchRadius
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -radius // flush with the edge: only the top corners show
                radius: win.notchRadius
                color: Appearance.colors.colLayer0
                border.width: 1
                border.color: Appearance.colors.colLayer0Border

                Behavior on width {
                    NumberAnimation { duration: 380; easing.type: Easing.OutBack; easing.overshoot: 1.1 }
                }
                Behavior on height {
                    NumberAnimation { duration: 320; easing.type: Easing.OutBack; easing.overshoot: 1.2 }
                }

                Rectangle {
                    anchors.horizontalCenter: parent.horizontalCenter
                    y: 3
                    width: 36
                    height: 4
                    radius: 2
                    color: Appearance.colors.colOnLayer1Inactive
                    opacity: win.expanded ? 0 : 0.8
                    Behavior on opacity { NumberAnimation { duration: 150 } }
                }

                RowLayout {
                    id: row
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    spacing: 6
                    opacity: win.expanded ? 1 : 0
                    scale: win.expanded ? 1 : 0.9
                    transformOrigin: Item.Bottom
                    Behavior on opacity { NumberAnimation { duration: win.expanded ? 220 : 90 } }
                    Behavior on scale { NumberAnimation { duration: 300; easing.type: Easing.OutBack } }

                    Repeater {
                        model: TaskbarApps.apps

                        delegate: Item {
                            id: cell

                            required property var modelData
                            readonly property bool isSep: modelData.appId === "SEPARATOR"
                            readonly property var toplevels: modelData.toplevels
                            readonly property bool running: toplevels.length > 0
                            readonly property bool active: toplevels.some(t => t.activated)

                            Layout.alignment: Qt.AlignVCenter
                            implicitWidth: isSep ? 10 : win.iconSize + 8
                            implicitHeight: win.iconSize + 8

                            Rectangle { // separator
                                visible: cell.isSep
                                anchors.centerIn: parent
                                width: 2
                                height: win.iconSize * 0.7
                                radius: 1
                                color: Appearance.colors.colOutlineVariant
                            }

                            Item {
                                id: tile
                                visible: !cell.isSep
                                anchors.centerIn: parent
                                width: win.iconSize
                                height: win.iconSize
                                scale: mouse.pressed ? 0.88 : (mouse.containsMouse ? 1.22 : 1)
                                transformOrigin: Item.Bottom
                                Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutBack; easing.overshoot: 2 } }

                                Rectangle {
                                    anchors.fill: parent
                                    radius: width * 0.3
                                    color: cell.active ? Appearance.colors.colLayer1Active
                                         : mouse.containsMouse ? Appearance.colors.colLayer1Hover : "transparent"
                                    Behavior on color { ColorAnimation { duration: 150 } }
                                }

                                AppIcon {
                                    anchors.centerIn: parent
                                    implicitSize: win.iconSize * 0.78
                                    source: AppSearch.guessIcon(cell.modelData.appId)
                                }

                                Rectangle { // running indicator
                                    visible: cell.running
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    anchors.top: parent.bottom
                                    anchors.topMargin: 1
                                    width: cell.active ? 14 : 5
                                    height: 4
                                    radius: 2
                                    color: cell.active ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer1Inactive
                                    Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutBack } }
                                }
                            }

                            MouseArea {
                                id: mouse
                                visible: !cell.isSep
                                anchors.fill: parent
                                hoverEnabled: true
                                acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton
                                onClicked: event => {
                                    if (event.button === Qt.RightButton) {
                                        TaskbarApps.togglePin(cell.modelData.appId);
                                    } else if (event.button === Qt.MiddleButton || !cell.running) {
                                        DesktopEntries.heuristicLookup(cell.modelData.appId)?.execute();
                                    } else {
                                        const list = cell.toplevels;
                                        const i = list.findIndex(t => t.activated);
                                        list[(i + 1) % list.length].activate();
                                    }
                                }
                            }

                            StyledToolTip {
                                extraVisibleCondition: mouse.containsMouse && !cell.isSep
                                text: DesktopEntries.heuristicLookup(cell.modelData.appId)?.name ?? cell.modelData.appId
                            }
                        }
                    }
                }
            }
        }
    }
}
