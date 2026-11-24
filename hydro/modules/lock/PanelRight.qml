import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ColumnLayout {
    id: root
    spacing: 16

    LockCard { // resources
        Layout.fillWidth: true
        Repeater {
            model: [
                { icon: "memory", label: "CPU", value: ResourceUsage.cpuUsage },
                { icon: "memory_alt", label: "RAM", value: ResourceUsage.memoryUsedPercentage },
                { icon: "swap_horiz", label: "Swap", value: ResourceUsage.swapUsedPercentage }
            ]
            delegate: RowLayout {
                id: rr
                required property var modelData
                Layout.fillWidth: true
                spacing: 12
                MaterialSymbol { text: rr.modelData.icon; iconSize: 22; color: Appearance.colors.colPrimary }
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    RowLayout {
                        Layout.fillWidth: true
                        StyledText { Layout.fillWidth: true; text: rr.modelData.label; font.pixelSize: Appearance.font.pixelSize.small; color: Appearance.colors.colSubtext }
                        StyledText { text: Math.round(rr.modelData.value * 100) + "%"; font.pixelSize: Appearance.font.pixelSize.small; color: Appearance.colors.colOnLayer1 }
                    }
                    Rectangle {
                        Layout.fillWidth: true
                        implicitHeight: 8
                        radius: 4
                        color: Qt.rgba(1, 1, 1, 0.10)
                        Rectangle {
                            width: parent.width * Math.max(0, Math.min(1, rr.modelData.value))
                            height: parent.height
                            radius: 4
                            color: rr.modelData.value > 0.85 ? Appearance.m3colors.m3error : Appearance.colors.colPrimary
                            Behavior on width { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
                        }
                    }
                }
            }
        }
    }

    LockCard { // notifications
        Layout.fillWidth: true
        RowLayout {
            Layout.fillWidth: true
            MaterialSymbol { text: "notifications"; iconSize: 20; color: Appearance.colors.colPrimary }
            StyledText {
                Layout.fillWidth: true
                text: Notifications.list.length > 0 ? Translation.tr("Notifications") : Translation.tr("No notifications")
                font.pixelSize: Appearance.font.pixelSize.normal
                font.weight: Font.DemiBold
                color: Appearance.colors.colOnLayer1
            }
            StyledText {
                visible: Notifications.list.length > 0
                text: Notifications.list.length
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.colors.colSubtext
            }
        }
        Repeater {
            model: Math.min(4, Notifications.list.length)
            delegate: Rectangle {
                id: nr
                required property int index
                readonly property var n: Notifications.list[Notifications.list.length - 1 - index]
                Layout.fillWidth: true
                implicitHeight: nCol.implicitHeight + 16
                radius: 18
                color: Qt.rgba(1, 1, 1, 0.08)
                ColumnLayout {
                    id: nCol
                    anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; margins: 12 }
                    spacing: 1
                    StyledText {
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        text: nr.n?.appName ?? ""
                        font.pixelSize: Appearance.font.pixelSize.smallest
                        color: Appearance.colors.colSubtext
                    }
                    StyledText {
                        Layout.fillWidth: true
                        elide: Text.ElideRight
                        text: nr.n?.summary ?? ""
                        font.pixelSize: Appearance.font.pixelSize.small
                        font.weight: Font.Medium
                        color: Appearance.colors.colOnLayer1
                    }
                }
            }
        }
    }
}
