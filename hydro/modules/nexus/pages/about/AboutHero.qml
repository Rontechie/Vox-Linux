import QtQuick
import QtQuick.Effects
import qs.modules.nexus.compat
import qs.modules.nexus.components
import qs.modules.nexus.services

Item {
    id: root

    property string title: "Hydro"
    property string subtitle
    property string badge
    property real energy: 1 // >1 = blobs move faster (used while updating)

    readonly property color baseColour: Colours.light ? Colours.palette.m3surfaceContainerHigh : Qt.darker(Colours.palette.m3surface, 1.7)

    property real parX: 0
    property real parY: 0
    Behavior on parX {
        Anim { type: Anim.SlowSpatial }
    }
    Behavior on parY {
        Anim { type: Anim.SlowSpatial }
    }
    HoverHandler {
        id: hover
        onPointChanged: {
            root.parX = (point.position.x / Math.max(1, root.width) - 0.5) * -70;
            root.parY = (point.position.y / Math.max(1, root.height) - 0.5) * -50;
        }
        onHoveredChanged: if (!hovered) {
            root.parX = 0;
            root.parY = 0;
        }
    }

    implicitHeight: 340

    layer.enabled: true
    layer.effect: MultiEffect {
        maskEnabled: true
        maskSource: mask
        maskThresholdMin: 0.5
        maskSpreadAtMin: 1.0
    }
    Item {
        id: mask
        anchors.fill: parent
        visible: false
        layer.enabled: true
        Rectangle {
            anchors.fill: parent
            radius: Tokens.rounding.extraLarge
        }
    }

    Rectangle {
        anchors.fill: parent
        color: root.baseColour
    }

    component Blob: Rectangle {
        id: b

        property real stageW
        property real stageH
        property real cx: 0.5
        property real cy: 0.5
        property real driftX: 0.1
        property real driftY: 0.1
        property real sizeFrac: 0.6
        property real phase: 0
        property int period: 9000
        property real t: 0

        width: stageW * sizeFrac
        height: width
        radius: width / 2
        x: stageW * (cx + driftX * Math.sin(t + phase)) - width / 2
        y: stageH * (cy + driftY * Math.cos(t + phase)) - height / 2

        NumberAnimation on t {
            from: 0
            to: Math.PI * 2
            duration: b.period / Math.max(0.2, root.energy)
            loops: Animation.Infinite
            running: root.visible
        }
    }

    Item {
        id: blobs
        anchors.fill: parent
        anchors.margins: -80
        transform: Translate {
            x: root.parX
            y: root.parY
        }
        layer.enabled: true
        layer.effect: MultiEffect {
            blurEnabled: true
            blur: 1.0
            blurMax: 100
            autoPaddingEnabled: false
        }

        Blob { // top, cool
            stageW: blobs.width; stageH: blobs.height
            cx: 0.6; cy: 0.3; driftX: 0.12; driftY: 0.1; sizeFrac: 0.55; phase: 0; period: 11000
            color: Qt.alpha(Colours.palette.m3primary, Colours.light ? 0.45 : 0.6)
        }
        Blob { // bottom, warm
            stageW: blobs.width; stageH: blobs.height
            cx: 0.38; cy: 0.78; driftX: 0.14; driftY: 0.08; sizeFrac: 0.6; phase: 2.1; period: 13000
            color: Qt.alpha(Colours.palette.m3tertiary, Colours.light ? 0.4 : 0.55)
        }
        Blob { // small accent
            stageW: blobs.width; stageH: blobs.height
            cx: 0.78; cy: 0.62; driftX: 0.1; driftY: 0.12; sizeFrac: 0.32; phase: 4.2; period: 9000
            color: Qt.alpha(Colours.palette.m3secondary, Colours.light ? 0.35 : 0.45)
        }
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: Qt.alpha(root.baseColour, 0.55) }
            GradientStop { position: 0.45; color: Qt.alpha(root.baseColour, 0) }
            GradientStop { position: 1.0; color: Qt.alpha(root.baseColour, 0.7) }
        }
    }

    Column {
        anchors.centerIn: parent
        spacing: Tokens.spacing.small

        Row {
            id: letters
            anchors.horizontalCenter: parent.horizontalCenter

            Repeater {
                model: root.title.split("")

                delegate: StyledText {
                    id: letter

                    required property string modelData
                    required property int index

                    text: modelData
                    color: Colours.palette.m3primary
                    font: Tokens.makeFont(Tokens.sansFamily, 64, Font.Bold, ({ "ROND": 100, "wdth": 112 }))
                    opacity: 0
                    transform: Translate {
                        id: lift
                        y: 46
                    }

                    SequentialAnimation {
                        running: true
                        PauseAnimation { duration: 150 + letter.index * 70 }
                        ParallelAnimation {
                            Anim { target: letter; property: "opacity"; to: 1; type: Anim.DefaultEffects }
                            Anim { target: lift; property: "y"; to: 0; type: Anim.SlowSpatial }
                        }
                    }
                }
            }
        }

        StyledText {
            id: sub
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.subtitle
            visible: text.length > 0
            color: Colours.palette.m3onSurfaceVariant
            font: Tokens.font.body.large
            opacity: 0
            animate: true
            SequentialAnimation {
                running: true
                PauseAnimation { duration: 750 }
                Anim { target: sub; property: "opacity"; to: 1; type: Anim.SlowEffects }
            }
        }

        StyledRect {
            id: pill
            anchors.horizontalCenter: parent.horizontalCenter
            readonly property bool shown: root.badge.length > 0
            implicitWidth: badgeText.implicitWidth + Tokens.padding.large * 2
            implicitHeight: badgeText.implicitHeight + Tokens.padding.small * 2
            radius: Tokens.rounding.full
            color: Colours.palette.m3tertiaryContainer
            scale: shown ? 1 : 0
            opacity: shown ? 1 : 0
            visible: opacity > 0
            Behavior on scale { Anim { type: Anim.FastSpatial } }
            Behavior on opacity { Anim { type: Anim.DefaultEffects } }
            StyledText {
                id: badgeText
                anchors.centerIn: parent
                text: root.badge
                color: Colours.palette.m3onTertiaryContainer
                font: Tokens.font.label.medium
            }
        }
    }
}
