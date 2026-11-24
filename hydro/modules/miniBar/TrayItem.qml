import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray

MouseArea {
    id: root
    required property SystemTrayItem item

    implicitWidth: 18
    implicitHeight: 18
    acceptedButtons: Qt.LeftButton | Qt.MiddleButton | Qt.RightButton

    onClicked: mouse => {
        if (mouse.button === Qt.LeftButton) {
            item.activate()
        } else if (mouse.button === Qt.MiddleButton) {
            item.secondaryActivate()
        } else if (item.hasMenu) {
            const p = root.mapToItem(null, 0, 0)
            item.display(root.QsWindow.window, p.x, p.y)
        }
    }

    IconImage {
        anchors.fill: parent
        source: root.item.icon
    }
}
