import QtQuick
import qs.modules.nexus.compat
import qs.modules.nexus.components
import qs.modules.nexus.services

Item {
    id: root

    property real value
    property real radius: Tokens.rounding.small
    property int cLayer: 1
    property color fgColour: Colours.palette.m3primary
    property color bgColour: Colours.layer(Colours.palette.m3surfaceContainerHighest, cLayer)

    signal interaction(real value)

    implicitHeight: Tokens.font.body.medium.pointSize + Tokens.padding.large * 2
    implicitWidth: 200
    opacity: enabled ? 1 : 0.38

    StyledRect {
        anchors.fill: parent
        radius: root.radius
        color: root.bgColour
    }

    StyledRect {
        width: Math.max(root.radius * 2, root.width * Math.max(0, Math.min(1, root.value)))
        height: parent.height
        radius: root.radius
        color: root.fgColour

        Behavior on width {
            enabled: !area.pressed
            Anim {
                type: Anim.FastEffects
            }
        }
    }

    MouseArea {
        id: area

        function setFromX(x: real): void {
            root.interaction(Math.max(0, Math.min(1, x / root.width)));
        }

        anchors.fill: parent
        enabled: root.enabled
        preventStealing: true
        cursorShape: Qt.PointingHandCursor
        onPressed: e => setFromX(e.x)
        onPositionChanged: e => {
            if (pressed)
                setFromX(e.x);
        }
    }
}
