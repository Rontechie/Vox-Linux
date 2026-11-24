import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

NxRow {
    id: root
    property string icon: ""
    property string text: ""
    property string subtext: ""
    property real value: 0
    property real from: 0
    property real to: 100
    property real step: 1
    property string suffix: ""
    signal changed(real v)
    clickable: false
    function bump(d) { root.changed(Math.max(from, Math.min(to, Math.round((value + d * step) * 1000) / 1000))) }

    component StepBtn: Rectangle {
        property string glyph
        signal tapped()
        implicitWidth: 36; implicitHeight: 36
        radius: ma.pressed ? 10 : 18
        color: Appearance.colors.colSecondaryContainer
        Behavior on radius { NumberAnimation { duration: 150 } }
        MaterialSymbol { anchors.centerIn: parent; text: parent.glyph; iconSize: 20; color: Appearance.colors.colOnSecondaryContainer }
        MouseArea { id: ma; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: parent.tapped() }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 10
        NxLabelBlock { icon: root.icon; text: root.text; subtext: root.subtext }
        StepBtn { glyph: "remove"; onTapped: root.bump(-1) }
        StyledText {
            Layout.preferredWidth: 62
            horizontalAlignment: Text.AlignHCenter
            text: root.value + root.suffix
            font.family: Appearance.font.family.monospace
            color: Appearance.m3colors.m3onSurface
        }
        StepBtn { glyph: "add"; onTapped: root.bump(1) }
    }
}
