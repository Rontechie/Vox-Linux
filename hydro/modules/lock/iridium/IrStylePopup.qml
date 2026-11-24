import QtQuick
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    readonly property var cfg: Config.options.lock.iridium
    property bool shown: false
    signal interacted()

    function openAt(px, py) {
        x = Math.max(0, Math.min(parent.width - width, px));
        y = Math.max(0, Math.min(parent.height - height, py));
        shown = true;
    }

    width: 288
    height: col.implicitHeight + 28
    radius: 22
    color: Appearance.colors.colLayer1
    border.width: 1
    border.color: Qt.rgba(1, 1, 1, 0.14)
    opacity: shown ? 1 : 0
    scale: shown ? 1 : 0.92
    transformOrigin: Item.TopLeft
    visible: opacity > 0.01
    Behavior on opacity { NumberAnimation { duration: 160 } }
    Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutBack } }

    MouseArea { anchors.fill: parent; acceptedButtons: Qt.LeftButton | Qt.RightButton; onClicked: root.interacted() }

    Column {
        id: col
        anchors.fill: parent
        anchors.margins: 14
        spacing: 10

        StyledText {
            text: Translation.tr("Lock clock")
            font.pixelSize: Appearance.font.pixelSize.normal
            font.weight: Font.DemiBold
            color: Appearance.colors.colOnLayer1
        }

        Grid {
            columns: 2
            spacing: 8
            Repeater {
                model: [
                    { value: "gear", label: Translation.tr("Gear"), icon: "settings" },
                    { value: "circle", label: Translation.tr("Circle"), icon: "schedule" },
                    { value: "digitalV", label: Translation.tr("Stacked"), icon: "view_agenda" },
                    { value: "digitalH", label: Translation.tr("Side by side"), icon: "view_column" }
                ]
                delegate: Rectangle {
                    id: tile
                    required property var modelData
                    readonly property bool on: root.cfg.clockStyle === modelData.value
                    width: (col.width - 8) / 2
                    height: 64
                    radius: on ? 24 : 14
                    color: on ? Appearance.colors.colPrimary : Appearance.colors.colLayer2
                    Behavior on radius { NumberAnimation { duration: 180 } }
                    Behavior on color { ColorAnimation { duration: 140 } }
                    Column {
                        anchors.centerIn: parent
                        spacing: 2
                        MaterialSymbol {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: tile.modelData.icon
                            iconSize: 24
                            color: tile.on ? Appearance.colors.colOnPrimary : Appearance.colors.colPrimary
                        }
                        StyledText {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: tile.modelData.label
                            font.pixelSize: Appearance.font.pixelSize.smaller
                            color: tile.on ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer2
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: { root.cfg.clockStyle = tile.modelData.value; root.interacted(); }
                    }
                }
            }
        }

        Flow {
            width: col.width
            spacing: 8
            opacity: (root.cfg.clockStyle === "gear" || root.cfg.clockStyle === "circle") ? 1 : 0.35
            IrChip {
                icon: root.cfg.showHands ? "check_circle" : "circle"
                text: Translation.tr("Hands")
                on: root.cfg.showHands
                onClicked: {
                    root.cfg.showHands = !root.cfg.showHands;
                    if (!root.cfg.showHands && !root.cfg.showNumbers) root.cfg.showNumbers = true;
                    root.interacted();
                }
            }
            IrChip {
                icon: root.cfg.showNumbers ? "check_circle" : "circle"
                text: Translation.tr("Numbers")
                on: root.cfg.showNumbers
                onClicked: {
                    root.cfg.showNumbers = !root.cfg.showNumbers;
                    if (!root.cfg.showNumbers && !root.cfg.showHands) root.cfg.showHands = true;
                    root.interacted();
                }
            }
        }

        Flow {
            width: col.width
            spacing: 8
            IrChip {
                icon: "splitscreen_left"
                text: Translation.tr("Side layout")
                on: root.cfg.horizontal
                onClicked: { root.cfg.horizontal = !root.cfg.horizontal; root.interacted(); }
            }
            IrChip {
                icon: "graphic_eq"
                text: Translation.tr("Visualizer")
                on: root.cfg.cavaEnabled
                onClicked: { root.cfg.cavaEnabled = !root.cfg.cavaEnabled; root.interacted(); }
            }
        }

        Row {
            spacing: 8
            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                text: Translation.tr("Size")
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.colors.colSubtext
            }
            IrChip {
                icon: "remove"
                onClicked: { root.cfg.clockScale = Math.max(0.5, Math.round((root.cfg.clockScale - 0.1) * 10) / 10); root.interacted(); }
            }
            StyledText {
                anchors.verticalCenter: parent.verticalCenter
                text: Math.round(root.cfg.clockScale * 100) + "%"
                color: Appearance.colors.colOnLayer1
            }
            IrChip {
                icon: "add"
                onClicked: { root.cfg.clockScale = Math.min(1.5, Math.round((root.cfg.clockScale + 0.1) * 10) / 10); root.interacted(); }
            }
        }
    }
}
