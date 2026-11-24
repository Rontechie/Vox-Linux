import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    property bool expanded: false
    readonly property int count: Notifications.list.length

    implicitHeight: 40
    implicitWidth: label.implicitWidth + 52
    radius: height / 2
    color: expanded ? Appearance.colors.colPrimary : Appearance.colors.colSecondaryContainer
    Behavior on color { ColorAnimation { duration: 160 } }

    Row {
        anchors.centerIn: parent
        spacing: 8
        MaterialSymbol {
            anchors.verticalCenter: parent.verticalCenter
            text: root.count > 0 ? "notifications_unread" : "notifications"
            iconSize: 18
            color: root.expanded ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSecondaryContainer
        }
        StyledText {
            id: label
            anchors.verticalCenter: parent.verticalCenter
            text: root.count > 0 ? root.count : Translation.tr("None")
            font.pixelSize: Appearance.font.pixelSize.small
            color: root.expanded ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSecondaryContainer
        }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.expanded = !root.expanded
    }

    Rectangle {
        id: panel
        z: 20
        width: 360
        height: Math.min(360, listCol.implicitHeight + 24)
        x: (root.width - width) / 2
        y: -height - 10
        radius: 24
        color: Appearance.colors.colLayer1
        border.width: 1
        border.color: Qt.rgba(1, 1, 1, 0.14)
        opacity: root.expanded ? 1 : 0
        scale: root.expanded ? 1 : 0.94
        transformOrigin: Item.Bottom
        visible: opacity > 0.01
        clip: true
        Behavior on opacity { NumberAnimation { duration: 160 } }
        Behavior on scale { NumberAnimation { duration: 220; easing.type: Easing.OutBack } }

        ColumnLayout {
            id: listCol
            anchors.fill: parent
            anchors.margins: 12
            spacing: 8

            RowLayout {
                Layout.fillWidth: true
                StyledText {
                    Layout.fillWidth: true
                    text: root.count > 0 ? Translation.tr("Notifications") : Translation.tr("No notifications")
                    font.pixelSize: Appearance.font.pixelSize.normal
                    font.weight: Font.DemiBold
                    color: Appearance.colors.colOnLayer1
                }
                IrChip {
                    visible: root.count > 0
                    icon: "clear_all"
                    text: Translation.tr("Clear")
                    onClicked: Notifications.discardAllNotifications()
                }
            }

            Repeater {
                model: Math.min(4, root.count)
                delegate: Rectangle {
                    id: item
                    required property int index
                    readonly property var n: Notifications.list[Notifications.list.length - 1 - index]
                    Layout.fillWidth: true
                    implicitHeight: itemCol.implicitHeight + 16
                    radius: 16
                    color: Appearance.colors.colLayer2
                    ColumnLayout {
                        id: itemCol
                        anchors.fill: parent
                        anchors.margins: 8
                        spacing: 1
                        StyledText {
                            Layout.fillWidth: true
                            text: item.n?.appName ?? ""
                            font.pixelSize: Appearance.font.pixelSize.smaller
                            color: Appearance.colors.colSubtext
                            elide: Text.ElideRight
                        }
                        StyledText {
                            Layout.fillWidth: true
                            text: item.n?.summary ?? ""
                            font.weight: Font.Medium
                            color: Appearance.colors.colOnLayer2
                            elide: Text.ElideRight
                        }
                        StyledText {
                            Layout.fillWidth: true
                            visible: text.length > 0
                            text: item.n?.body ?? ""
                            font.pixelSize: Appearance.font.pixelSize.small
                            color: Appearance.colors.colSubtext
                            elide: Text.ElideRight
                            maximumLineCount: 2
                            wrapMode: Text.Wrap
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: if (item.n) Notifications.discardNotification(item.n.notificationId)
                    }
                }
            }
        }
    }
}
