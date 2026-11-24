import QtQuick
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: p
    property var pal
    property string glyph
    property bool confirming: false
    signal clicked()
    height: 40; width: confirming ? 40 + lt.implicitWidth + 14 : 40; radius: height / 2; clip: true
    Behavior on width { NumberAnimation { duration: 280; easing.type: Easing.OutBack; easing.overshoot: 1.3 } }
    color: confirming ? pal.errorContainer : (ma.containsMouse ? pal.containerHighest : pal.containerHigh)
    Behavior on color { ColorAnimation { duration: 180 } }
    scale: ma.pressed ? 0.92 : 1
    Behavior on scale { SpringAnimation { spring: 5; damping: 0.4 } }
    GlyphIcon { x: 10; y: 10; width: 20; height: 20; glyph: p.glyph; color: p.confirming ? p.pal.error : p.pal.fg }
    StyledText { id: lt; x: 38; anchors.verticalCenter: parent.verticalCenter; text: "Confirm"; font.pixelSize: 12; font.bold: true
        color: p.pal.error; opacity: p.confirming ? 1 : 0; Behavior on opacity { NumberAnimation { duration: 160 } } }
    MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: p.clicked() }
}
