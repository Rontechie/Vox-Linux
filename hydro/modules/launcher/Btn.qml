import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import QtQuick.Layouts

Rectangle {
    id: b
    property var pal
    property string text
    property string glyph
    property bool danger: false
    signal clicked()
    Layout.fillWidth: true; implicitHeight: 42; radius: 21
    color: danger ? pal.errorContainer : pal.containerHigh
    scale: ma.pressed ? 0.95 : 1
    Behavior on scale { SpringAnimation { spring: 5; damping: 0.4 } }
    Rectangle { anchors.fill: parent; radius: parent.radius; color: b.pal.fg; opacity: ma.pressed ? 0.14 : ma.containsMouse ? 0.08 : 0
        Behavior on opacity { NumberAnimation { duration: 140 } } }
    Row {
        anchors.centerIn: parent; spacing: 8
        GlyphIcon { glyph: b.glyph; width: 18; height: 18; color: b.danger ? b.pal.error : b.pal.fg; anchors.verticalCenter: parent.verticalCenter }
        StyledText { text: b.text; font.pixelSize: 12; font.bold: true; color: b.danger ? b.pal.error : b.pal.fg; anchors.verticalCenter: parent.verticalCenter }
    }
    MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: b.clicked() }
}
