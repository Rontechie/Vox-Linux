import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.widgets.settings

Rectangle {
    required property var manager

    id: lane
    required property string laneName
    readonly property var ids: manager.listOf(laneName)
    property alias repeater: rep

    Layout.fillWidth: true
    Layout.preferredWidth: 1
    Layout.alignment: Qt.AlignTop
    implicitHeight: Math.max(col.implicitHeight + 24, 230)
    radius: SettingsTheme.cornerRadius
    color: Appearance.colors.colLayer0
    border.width: 1
    border.color: SettingsTheme.withAlpha(SettingsTheme.outline, 0.7)

    ColumnLayout {
        id: col
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 12
        }
        spacing: 6

        StyledText {
            text: manager.laneTitles[lane.laneName]
            font.family: Appearance.font.family.monospace
            font.pixelSize: SettingsTheme.fontSizeSmall - 1
            font.letterSpacing: 1.5
            font.capitalization: Font.AllUppercase
            color: SettingsTheme.primary
            Layout.bottomMargin: 4
        }

        Repeater {
            id: rep
            model: lane.ids

            delegate: Item {
                id: cell
                required property string modelData
                readonly property bool isHidden: manager.hiddenIds.indexOf(modelData) >= 0

                Layout.fillWidth: true
                implicitHeight: 40

                Rectangle {
                    id: card
                    width: cell.width
                    height: cell.height
                    radius: SettingsTheme.cornerRadius - 3
                    color: handle.drag.active ? SettingsTheme.withAlpha(SettingsTheme.primary, 0.22) : Appearance.colors.colLayer2
                    border.width: handle.drag.active ? 1 : 0
                    border.color: SettingsTheme.primary
                    z: handle.drag.active ? 100 : 0
                    opacity: cell.isHidden ? 0.5 : 1
                    scale: handle.drag.active ? 1.03 : 1
                    Behavior on scale { NumberAnimation { duration: 120 } }

                    RowLayout {
                        anchors {
                            fill: parent
                            leftMargin: 8
                            rightMargin: 6
                        }
                        spacing: 8

                        MaterialSymbol {
                            text: "drag_indicator"
                            iconSize: 20
                            color: SettingsTheme.surfaceVariantText
                        }
                        MaterialSymbol {
                            text: manager.iconOf(cell.modelData)
                            iconSize: 18
                            color: SettingsTheme.primary
                        }
                        StyledText {
                            Layout.fillWidth: true
                            text: manager.nameOf(cell.modelData)
                            elide: Text.ElideRight
                            font.pixelSize: SettingsTheme.fontSizeMedium
                            font.weight: Font.Medium
                            color: SettingsTheme.surfaceText
                        }
                        Item {
                            implicitWidth: 26
                            implicitHeight: 26
                            MaterialSymbol {
                                anchors.centerIn: parent
                                text: cell.isHidden ? "visibility_off" : "visibility"
                                iconSize: 18
                                color: SettingsTheme.surfaceVariantText
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: manager.toggleHidden(cell.modelData)
                            }
                        }
                        Item {
                            implicitWidth: 26
                            implicitHeight: 26
                            MaterialSymbol {
                                anchors.centerIn: parent
                                text: "close"
                                iconSize: 18
                                color: SettingsTheme.surfaceVariantText
                            }
                            MouseArea {
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: manager.removeWidget(lane.laneName, cell.modelData)
                            }
                        }
                    }
                }

                MouseArea { // drag handle
                    id: handle
                    width: 40
                    height: cell.height
                    drag.target: card
                    cursorShape: drag.active ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                    onReleased: {
                        const p = card.mapToItem(manager.lanesRowItem, card.width / 2, card.height / 2);
                        card.x = 0;
                        card.y = 0;
                        manager.drop(cell.modelData, lane.laneName, p);
                    }
                }
            }
        }

        Rectangle { // + Add Widget
            Layout.fillWidth: true
            Layout.topMargin: 4
            implicitHeight: 36
            radius: SettingsTheme.cornerRadius - 3
            color: addHover.hovered ? SettingsTheme.withAlpha(SettingsTheme.primary, 0.12) : "transparent"
            border.width: 1
            border.color: SettingsTheme.withAlpha(SettingsTheme.outline, 0.8)
            opacity: manager.available.length > 0 ? 1 : 0.4

            Row {
                anchors.centerIn: parent
                spacing: 6
                MaterialSymbol { text: "add"; iconSize: 18; color: SettingsTheme.surfaceText; anchors.verticalCenter: parent.verticalCenter }
                StyledText { text: Translation.tr("Add Widget"); font.pixelSize: SettingsTheme.fontSizeMedium; color: SettingsTheme.surfaceText; anchors.verticalCenter: parent.verticalCenter }
            }
            HoverHandler { id: addHover }
            TapHandler {
                enabled: manager.available.length > 0
                onTapped: addPopup.open()
            }
        }
    }

    Popup {
        id: addPopup
        x: (parent.width - width) / 2
        y: parent.height - 40 - height > 0 ? parent.height - 40 - height : 8
        width: Math.min(220, parent.width - 16)
        padding: 6
        modal: false
        focus: true
        closePolicy: Popup.CloseOnPressOutside | Popup.CloseOnEscape
        background: Rectangle {
            radius: SettingsTheme.cornerRadius
            color: Appearance.m3colors.m3surfaceContainerHigh
            border.width: 1
            border.color: SettingsTheme.withAlpha(SettingsTheme.outline, 0.8)
        }
        contentItem: Flickable {
            implicitHeight: Math.min(260, menuCol.implicitHeight)
            contentHeight: menuCol.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            Column {
                id: menuCol
                width: parent.width
                spacing: 2
                Repeater {
                    model: manager.available
                    delegate: Rectangle {
                        id: opt
                        required property string modelData
                        width: menuCol.width
                        height: 34
                        radius: 8
                        color: optHover.hovered ? SettingsTheme.withAlpha(SettingsTheme.primary, 0.16) : "transparent"
                        Row {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            spacing: 8
                            MaterialSymbol { text: manager.iconOf(opt.modelData); iconSize: 18; color: SettingsTheme.primary; anchors.verticalCenter: parent.verticalCenter }
                            StyledText { text: manager.nameOf(opt.modelData); font.pixelSize: SettingsTheme.fontSizeMedium; color: SettingsTheme.surfaceText; anchors.verticalCenter: parent.verticalCenter }
                        }
                        HoverHandler { id: optHover }
                        TapHandler {
                            onTapped: {
                                manager.addWidget(lane.laneName, opt.modelData);
                                addPopup.close();
                            }
                        }
                    }
                }
            }
        }
    }
}
