import QtQuick
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    property string icon: ""
    property string text: ""
    property bool on: false
    signal clicked()

    implicitHeight: 32
    implicitWidth: row.implicitWidth + 24
    radius: height / 2
    color: on ? Qt.rgba(Appearance.colors.colPrimary.r, Appearance.colors.colPrimary.g, Appearance.colors.colPrimary.b, 0.22)
              : (hover.hovered ? Appearance.colors.colLayer2Hover : Appearance.colors.colLayer2)
    border.width: 1
    border.color: on ? Appearance.colors.colPrimary : "transparent"
    Behavior on color { ColorAnimation { duration: 140 } }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 6
        MaterialSymbol {
            visible: root.icon !== ""
            anchors.verticalCenter: parent.verticalCenter
            text: root.icon
            iconSize: 16
            color: root.on ? Appearance.colors.colPrimary : Appearance.colors.colOnLayer2
        }
        StyledText {
            anchors.verticalCenter: parent.verticalCenter
            text: root.text
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.colors.colOnLayer2
        }
    }
    HoverHandler { id: hover }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
