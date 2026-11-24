import QtQuick
import QtQuick.Effects
import qs.modules.desktopWidgets.ui

Item {
    id: sha
    property string artUrl: HwState.mediaArtUrl
    property string shape: "Cookie9Sided"
    property color fallbackColor: HwM3.secondaryContainer
    property color iconColor: HwM3.inkSecondaryContainer
    property bool spinning: false
    property real spinSpeed: 18
    property real spin: 0
    FrameAnimation {
        running: sha.spinning && sha.visible
        onTriggered: sha.spin = (sha.spin + sha.spinSpeed * Math.min(frameTime, 0.05)) % 360
    }
    Item {
        anchors.fill: parent
        rotation: sha.spin
        MBox {
            anchors.fill: parent
            from: sha.shape
            fill: sha.fallbackColor
            visible: shaImg.status !== Image.Ready
        }
        Text {
            anchors.centerIn: parent
            visible: shaImg.status !== Image.Ready
            rotation: -sha.spin
            text: ""
            font.family: "Material Symbols Rounded"; font.pixelSize: Math.max(10, Math.round(sha.width * 0.38))
            color: sha.iconColor
        }
        Image {
            id: shaImg
            anchors.fill: parent
            sourceSize: Qt.size(256, 256)
            fillMode: Image.PreserveAspectCrop
            source: sha.artUrl
            asynchronous: true
            visible: status === Image.Ready
            layer.enabled: visible
            layer.smooth: true
            layer.effect: MultiEffect {
                maskEnabled: true
                maskSource: shaMask
                maskThresholdMin: 0.5
                maskSpreadAtMin: 0.05
            }
        }
        Item {
            id: shaMask
            anchors.fill: parent
            visible: false
            layer.enabled: true
            MBox { anchors.fill: parent; from: sha.shape; fill: "white" }
        }
    }
}
