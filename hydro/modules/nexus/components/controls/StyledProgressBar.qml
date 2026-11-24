import QtQuick
import qs.modules.nexus.compat
import qs.modules.nexus.components
import qs.modules.nexus.services

Item {
    id: root

    property real value: 0
    property real from: 0
    property real to: 1
    property bool indeterminate: false
    property bool wavy
    property bool wavePaused
    property color fgColour: Colours.palette.m3primary
    property color bgColour: Colours.palette.m3secondaryContainer

    implicitHeight: Tokens.rounding.extraSmall
    implicitWidth: 200

    StyledRect {
        anchors.fill: parent
        radius: Tokens.rounding.full
        color: root.bgColour
    }

    StyledRect {
        id: bar

        readonly property real frac: root.to > root.from ? Math.max(0, Math.min(1, (root.value - root.from) / (root.to - root.from))) : 0

        visible: !root.indeterminate
        width: parent.width * frac
        height: parent.height
        radius: Tokens.rounding.full
        color: root.fgColour
    }

    StyledRect {
        id: seg

        visible: root.indeterminate
        width: parent.width * 0.3
        height: parent.height
        radius: Tokens.rounding.full
        color: root.fgColour

        SequentialAnimation on x {
            running: root.indeterminate && root.visible
            loops: Animation.Infinite
            NumberAnimation {
                from: 0
                to: root.width - seg.width
                duration: 900
                easing.type: Easing.InOutSine
            }
            NumberAnimation {
                from: root.width - seg.width
                to: 0
                duration: 900
                easing.type: Easing.InOutSine
            }
        }
    }
}
