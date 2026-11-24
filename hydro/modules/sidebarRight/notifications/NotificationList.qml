import qs.modules.common
import qs.modules.common.widgets
import qs.services
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Item {
    id: root

    NotificationListView { // Scrollable window
        id: listview
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: statusRow.top
        anchors.bottomMargin: 5

        clip: true
        layer.enabled: true
        layer.effect: OpacityMask {
            maskSource: Rectangle {
                width: listview.width
                height: listview.height
                radius: 28
            }
        }

        popup: false
    }

    PagePlaceholder {
        shown: Notifications.list.length === 0
        icon: "notifications_active"
        description: Translation.tr("Nothing")
        shape: MaterialShape.Shape.Ghostish
        descriptionHorizontalAlignment: Text.AlignHCenter
    }

    RowLayout { // Android 16 footer: separate pills with a wide "Clear all"
        id: statusRow
        spacing: 8
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        NotificationStatusButton {
            Layout.fillWidth: false
            buttonIcon: "notifications_paused"
            toggled: Notifications.silent
            onClicked: () => {
                Notifications.silent = !Notifications.silent;
            }
        }
        NotificationStatusButton {
            Layout.fillWidth: true
            enabled: Notifications.list.length > 0
            buttonText: Translation.tr("Clear all")
            onClicked: () => {
                Notifications.discardAllNotifications()
            }
        }
        NotificationStatusButton {
            Layout.fillWidth: false
            buttonIcon: "settings"
            onClicked: () => {
                Quickshell.execDetached(["qs", "-p", Quickshell.shellPath("nexus.qml")]);
            }
        }
    }
}