import QtQuick
import qs.modules.common.widgets
import qs.modules.desktopWidgets.ui

Rectangle {
    id: btn
    property string icon: ""
    property real iconSize: 22
    property color fill: HwM3.secondaryContainer
    property color ink: HwM3.inkSecondaryContainer
    signal clicked()
    implicitWidth: 40
    implicitHeight: 40
    radius: ma.pressed ? 12 : height / 2
    color: fill
    Behavior on radius { M3SpringAnim { token: "spatialFast" } }
    MaterialSymbol {
        anchors.centerIn: parent
        text: btn.icon
        iconSize: btn.iconSize
        fill: 1
        color: btn.ink
    }
    MouseArea {
        id: ma
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: btn.clicked()
    }
}
