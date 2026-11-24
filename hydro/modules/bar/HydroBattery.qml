import QtQuick
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    implicitWidth: track.width + 1 + nub.width
    implicitHeight: 34
    readonly property real ws: Config.options.bar.sizes.widgetScale
    readonly property real fs: Config.options.bar.sizes.fontScale

    readonly property real level: Math.max(0, Math.min(1, Battery.percentage))
    readonly property color fillColor: Battery.isLowAndNotCharging ? Appearance.m3colors.m3error
                                                                  : Appearance.colors.colPrimary
    readonly property color onFillColor: Battery.isLowAndNotCharging ? Appearance.m3colors.m3onError
                                                                     : Appearance.colors.colOnPrimary

    component Label: Item {
        property color fg: "white"
        anchors.fill: parent

        FontMetrics { id: fm; font: digits.font }
        TextMetrics { id: tm; font: digits.font; text: digits.text }
        readonly property real glyphShift: {
            const boxH = digits.height;
            const baseline = (boxH - fm.height) / 2 + fm.ascent;
            const glyphCenter = baseline + tm.tightBoundingRect.y + tm.tightBoundingRect.height / 2;
            return Math.max(-2, Math.min(2, Math.round(boxH / 2 - glyphCenter)));
        }

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: parent.glyphShift
            height: parent.height
            spacing: 0

            MaterialSymbol {
                visible: Battery.isCharging && root.level < 0.995
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                text: "bolt"
                iconSize: 11 * root.ws
                color: parent.parent.fg
            }
            StyledText {
                id: digits
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                text: Math.round(root.level * 100)
                font.pixelSize: 10 * root.fs
                font.weight: Font.Bold
                color: parent.parent.fg
            }
        }
    }

    Rectangle { // track
        id: track
        x: 0
        y: Math.round((root.height - height) / 2)
        width: 28 * root.ws
        height: 18 * root.ws
        radius: 6
        color: "#33ffffff"
        clip: true

        Label { fg: Appearance.colors.colOnLayer0 }

        Rectangle { // fill; carries its own copy of the label so the text stays readable
            height: parent.height
            width: Math.max(8, parent.width * root.level)
            radius: 6
            color: root.fillColor
            clip: true
            Behavior on width { animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }
            Behavior on color { ColorAnimation { duration: 200 } }

            Item { // same size as the track so the label lines up with the one underneath
                width: track.width
                height: track.height
                Label { fg: root.onFillColor }
            }
        }
    }

    Rectangle { // nub
        id: nub
        x: track.width + 1
        y: Math.round((root.height - height) / 2)
        width: 2
        height: 6
        radius: 1
        color: root.level >= 0.99 ? root.fillColor : "#33ffffff"
    }
}
