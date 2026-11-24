import QtQuick
import Quickshell.Services.SystemTray

Row {
    spacing: 10
    visible: repeater.count > 0

    Repeater {
        id: repeater
        model: SystemTray.items.values.filter(i => i.status !== Status.Passive)

        TrayItem {
            required property var modelData
            item: modelData
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
