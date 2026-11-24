import QtQuick

Item {
    id: sw
    property var pal
    property bool checked: false
    signal toggled(bool v)
    implicitWidth: 52; implicitHeight: 32
    Rectangle {
        anchors.fill: parent; radius: 16
        color: sw.checked ? sw.pal.primary : sw.pal.containerHighest
        border.width: sw.checked ? 0 : 2; border.color: sw.pal.onSurfaceVariant
        Behavior on color { ColorAnimation { duration: 220 } }
    }
    Rectangle {
        id: th
        width: ma.pressed ? 28 : sw.checked ? 24 : 16; height: width; radius: width / 2
        x: (sw.checked ? 36 : 16) - width / 2
        anchors.verticalCenter: parent.verticalCenter
        color: sw.checked ? sw.pal.fgOnPrimary : sw.pal.onSurfaceVariant
        Behavior on x { NumberAnimation { duration: 260; easing.type: Easing.OutBack; easing.overshoot: 1.3 } }
        Behavior on width { NumberAnimation { duration: 150; easing.type: Easing.OutCubic } }
        Behavior on color { ColorAnimation { duration: 220 } }
        GlyphIcon {
            anchors.centerIn: parent; width: 14; height: 14; glyph: "check"
            color: sw.pal.primary; opacity: sw.checked ? 1 : 0
            Behavior on opacity { NumberAnimation { duration: 180 } }
        }
    }
    MouseArea { id: ma; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sw.toggled(!sw.checked) }
}
