import qs.modules.common
import QtQuick
import QtQuick.Controls

Slider {
    id: root
    property list<real> stopIndicatorValues: [1] // kept for StyledSlider API parity
    property bool usePercentTooltip: true
    property string unit: ""
    property color highlightColor: Appearance.colors.colPrimary
    property color trackColor: Appearance.colors.colSecondaryContainer
    property color thumbOutlineColor: Appearance.colors.colLayer1
    property real trackOpacity: 1

    implicitHeight: 32
    padding: 0
    PointingHandInteraction {}

    background: Item {
        x: root.leftPadding
        y: root.topPadding
        width: root.availableWidth
        height: root.availableHeight

        Rectangle {
            id: track
            width: parent.width
            height: 8
            anchors.verticalCenter: parent.verticalCenter
            radius: height / 2
            color: root.trackColor
            opacity: root.trackOpacity

            Rectangle {
                width: Math.max(track.height, root.handle.x + root.handle.width / 2)
                height: parent.height
                radius: parent.radius
                color: root.highlightColor
            }
        }
    }

    handle: Rectangle {
        readonly property real size: root.pressed ? 24 : 20
        x: root.leftPadding + root.visualPosition * (root.availableWidth - width)
        y: root.topPadding + (root.availableHeight - height) / 2
        width: size
        height: size
        radius: size / 2
        color: root.highlightColor
        border.width: 3
        border.color: root.thumbOutlineColor

        Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
        Behavior on height { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

        Rectangle { // value bubble
            visible: root.pressed || root.hovered
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.top
            anchors.bottomMargin: 6
            width: bubbleText.implicitWidth + 16
            height: bubbleText.implicitHeight + 8
            radius: height / 2
            color: Appearance.colors.colSecondaryContainer
            StyledText {
                id: bubbleText
                anchors.centerIn: parent
                color: Appearance.m3colors.m3onSecondaryContainer
                font.pixelSize: Appearance.font.pixelSize.smaller
                text: root.usePercentTooltip
                    ? Math.round((root.value - root.from) / Math.max(1e-9, root.to - root.from) * 100) + "%"
                    : (Math.round(root.value * 100) / 100) + root.unit
            }
        }
    }
}
