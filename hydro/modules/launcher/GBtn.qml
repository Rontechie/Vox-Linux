import QtQuick

Item {
    id: b
    property var pal
    property string glyph
    property bool on: false
    property bool danger: false
    property bool spin: false
    property int sz: 38
    signal clicked()
    implicitWidth: sz; implicitHeight: sz
    scale: ma.pressed ? 0.9 : 1
    Behavior on scale { SpringAnimation { spring: 5; damping: 0.4 } }
    MorphShape {
        anchors.fill: parent
        shape: ma.pressed ? "square" : (b.on ? "cookie9" : "circle")
        spin: b.on && !ma.pressed; spinPeriod: 10000
        color: b.on ? b.pal.primary : (b.danger ? b.pal.errorContainer : b.pal.fg)
        opacity: b.on ? 1 : (ma.pressed ? 0.22 : ma.containsMouse ? 0.14 : 0)
        Behavior on opacity { NumberAnimation { duration: 140 } }
    }
    GlyphIcon {
        id: gl; anchors.centerIn: parent; width: Math.round(b.sz * 0.5); height: width; glyph: b.glyph
        color: b.on ? b.pal.fgOnPrimary : ((b.danger && ma.containsMouse) ? b.pal.error : b.pal.fg)
        Behavior on color { ColorAnimation { duration: 150 } }
    }
    RotationAnimation { id: rot; target: gl; from: 0; to: 360; duration: 550; easing.type: Easing.OutCubic }
    MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
        onClicked: { if (b.spin) rot.restart(); b.clicked() } }
}
