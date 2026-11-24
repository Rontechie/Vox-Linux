import QtQuick
import qs.modules.common

Item {
    id: root
    property string label
    property bool filled: false
    property bool busy: false
    property bool accentDot: false
    signal clicked()

    implicitHeight: 40
    implicitWidth: row.implicitWidth + 36
    opacity: enabled ? 1 : 0.4

    Rectangle {
        anchors.fill: parent
        radius: NothingTheme.pill
        color: root.filled ? NothingTheme.white : (area.containsMouse ? "#151515" : "transparent")
        border.width: root.filled ? 0 : 1
        border.color: area.containsMouse ? NothingTheme.white : NothingTheme.lineStrong
        Behavior on color { ColorAnimation { duration: 120 } }
    }
    Row {
        id: row
        anchors.centerIn: parent
        spacing: 10
        Rectangle { // status dot
            visible: root.busy || root.accentDot
            width: 7; height: 7; radius: 3.5
            anchors.verticalCenter: parent.verticalCenter
            color: NothingTheme.red
            SequentialAnimation on opacity {
                running: root.busy; loops: Animation.Infinite
                NumberAnimation { to: 0.15; duration: 450 }
                NumberAnimation { to: 1; duration: 450 }
            }
        }
        Text {
            text: root.label.toUpperCase()
            color: root.filled ? NothingTheme.black : NothingTheme.text
            font.family: NothingTheme.mono
            font.pixelSize: 12
            font.letterSpacing: 1.5
        }
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
