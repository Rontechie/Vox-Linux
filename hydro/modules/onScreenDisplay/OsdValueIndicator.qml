import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    required property real value
    required property string icon
    required property string name
    property bool rotateIcon: false
    property bool scaleIcon: false
    property real from: 0
    property real to: 1

    readonly property string style: Config.options.osd.style ?? "icon"
    readonly property real fraction: Math.max(0, Math.min(1, (value - from) / Math.max(0.0001, to - from)))

    property real shown: fraction
    Behavior on shown {
        NumberAnimation {
            duration: Appearance.animation.elementMoveFast.duration
            easing.type: Appearance.animation.elementMoveFast.type
            easing.bezierCurve: Appearance.animation.elementMoveFast.bezierCurve
        }
    }

        readonly property bool showPercent: style !== "bubble"
    readonly property real trackWidth: 120
    readonly property real trackHeight: style === "icon" ? 22 : (style === "dots" ? 8 : 5)
    readonly property real pad: 8
    readonly property real bubbleRoom: style === "bubble" ? 28 : 0
    readonly property real baseH: Math.max(trackHeight + 8, 20) + 2 * pad
    readonly property real iconCard: baseH
    readonly property real cardGap: 6
    readonly property real sidePct: showPercent ? 34 : 0

    implicitWidth: baseH + cardGap + pad * 2 + trackWidth + sidePct + 2 * Appearance.sizes.elevationMargin
    implicitHeight: bubbleRoom + baseH + 2 * Appearance.sizes.elevationMargin
    Behavior on implicitHeight { NumberAnimation { duration: 200; easing.type: Easing.OutCubic } }

    StyledRectangularShadow { target: iconBox }
    StyledRectangularShadow { target: card }

    Rectangle {
        id: iconBox
        x: Appearance.sizes.elevationMargin
        y: card.y + card.height - height
        height: root.style === "bubble" ? root.baseH : card.height
        width: height
        radius: 10
        color: Appearance.colors.colLayer0
        MaterialSymbol {
            anchors.centerIn: parent
            text: root.icon
            iconSize: 18 + (root.scaleIcon ? 3 * root.fraction : 0)
            rotation: root.rotateIcon ? 180 * root.fraction : 0
            color: Appearance.colors.colOnLayer0
        }
    }

    Rectangle {
        id: card
        anchors {
            fill: parent
            margins: Appearance.sizes.elevationMargin
            leftMargin: Appearance.sizes.elevationMargin + root.baseH + root.cardGap
        }
        radius: 10
        color: Appearance.colors.colLayer0

        Item {
            id: slider
            x: root.pad
            width: root.trackWidth
            height: root.trackHeight
            y: root.bubbleRoom + root.pad + (Math.max(root.trackHeight + 8, 20) - root.trackHeight) / 2

            readonly property real h: root.trackHeight
            readonly property real handleGap: 4
            readonly property real handleW: 4
            readonly property real fillW: Math.max(0, (width - handleW - handleGap) * root.shown)
            readonly property color fillColor: Appearance.colors.colPrimaryContainer

            Rectangle {
                anchors.fill: parent
                radius: root.style === "icon" ? 5 : Math.min(4, height / 2)
                color: Appearance.colors.colSecondaryContainer
                opacity: 0.55
            }

            Rectangle {
                id: fill
                width: slider.fillW
                height: slider.h
                radius: root.style === "icon" ? 5 : Math.min(4, height / 2)
                color: slider.fillColor
            }
            Rectangle {
                x: fill.width - Math.min(fill.width, slider.h / 2 + 2)
                width: Math.min(fill.width, slider.h / 2 + 2)
                height: slider.h
                radius: 2
                color: slider.fillColor
            }

            Repeater {
                model: root.style === "dots" ? 5 : 0
                delegate: Rectangle {
                    required property int index
                    readonly property real dx: 6 + index * ((slider.width - 24) / 4)
                    visible: dx + 2 < fill.width - 4
                    x: dx
                    anchors.verticalCenter: parent.verticalCenter
                    width: 3; height: 3; radius: 1.5
                    color: Appearance.colors.colOnPrimaryContainer
                    opacity: 0.8
                }
            }

            Rectangle {
                id: handle
                width: slider.handleW
                height: root.style === "icon" ? slider.h + 6 : (root.style === "dots" ? 16 : 14)
                radius: 2
                x: fill.width + slider.handleGap - 1
                anchors.verticalCenter: parent.verticalCenter
                color: Appearance.colors.colPrimary
            }

            Rectangle {
                visible: root.style === "bubble"
                width: Math.max(32, bubbleText.implicitWidth + 14)
                height: 24
                radius: 6
                color: Appearance.colors.colSecondaryContainer
                x: Math.max(0, Math.min(slider.width - width, handle.x + handle.width / 2 - width / 2))
                y: -height - 8
                StyledText {
                    id: bubbleText
                    anchors.centerIn: parent
                    text: Math.round(root.fraction * 100)
                    color: Appearance.colors.colOnSecondaryContainer
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    font.weight: Font.Medium
                }
            }
        }

        StyledText {
            visible: root.showPercent
            x: slider.x + slider.width + 6
            width: root.sidePct - 6
            y: slider.y + (slider.height - height) / 2
            horizontalAlignment: Text.AlignRight
            text: Math.round(root.fraction * 100) + "%"
            color: Appearance.colors.colOnLayer0
            font.pixelSize: Appearance.font.pixelSize.smaller
            font.weight: Font.Medium
        }
    }
}
