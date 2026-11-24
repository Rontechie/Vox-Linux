import qs.modules.common
import qs.modules.common.widgets
import QtQuick

Item {
    id: root
    property real s: 250
    property string style: "full"
    property bool hourMarks: false
    property color markColor: "white"
    readonly property real k: s / 250

    Repeater {
        model: root.style === "full" ? 60 : (root.style === "dots" ? 12 : 0)
        delegate: Item {
            id: tick
            required property int index
            readonly property bool full: root.style === "full"
            readonly property bool marked: root.hourMarks && (full ? index % 5 === 0 : index % 3 === 0)
            anchors.fill: parent
            rotation: index * (full ? 6 : 30)
            Rectangle {
                anchors.horizontalCenter: parent.horizontalCenter
                y: root.s * (tick.marked ? 0.105 : 0.115)
                width: (tick.marked ? 3.5 : (tick.full ? 1.6 : 4)) * root.k
                height: tick.marked ? root.s * 0.055 : (tick.full ? 6 : 4) * root.k
                radius: width / 2
                color: root.markColor
                opacity: tick.marked ? 0.7 : (tick.full ? 0.32 : 0.5)
            }
        }
    }

    Repeater {
        model: root.style === "numbers" ? 12 : 0
        delegate: StyledText {
            required property int index
            readonly property real a: index * Math.PI / 6
            x: root.s / 2 + Math.sin(a) * root.s * 0.335 - width / 2
            y: root.s / 2 - Math.cos(a) * root.s * 0.335 - height / 2
            text: index === 0 ? "12" : String(index)
            font.pixelSize: root.s * 0.08
            font.weight: Font.DemiBold
            color: root.markColor
        }
    }
}
