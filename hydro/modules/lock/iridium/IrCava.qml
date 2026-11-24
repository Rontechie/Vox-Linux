import QtQuick
import qs.modules.common
import qs.modules.desktopWidgets.ui

Item {
    id: root
    property bool active: false
    property string edge: "bottom"
    readonly property bool horizontal: edge === "bottom" || edge === "top"
    readonly property real thickness: 200
    readonly property var vals: HwCava.values
    readonly property int n: Math.max(16, Math.min(64, vals.length))

    visible: active
    opacity: 0.8
    anchors.fill: parent

    Item {
        id: strip
        x: root.edge === "right" ? root.width - root.thickness : 0
        y: root.edge === "bottom" ? root.height - root.thickness : 0
        width: root.horizontal ? root.width : root.thickness
        height: root.horizontal ? root.thickness : root.height
        clip: true

        Repeater {
            model: root.active ? root.n : 0
            delegate: Rectangle {
                required property int index
                readonly property real v: Math.min(1, root.vals[Math.floor(index * root.vals.length / root.n)] || 0)
                readonly property real slot: (root.horizontal ? strip.width : strip.height) / root.n
                property real len: Math.max(4, v * root.thickness * 0.95)
                width: root.horizontal ? Math.max(2, slot - 4) : len
                height: root.horizontal ? len : Math.max(2, slot - 4)
                radius: 3
                color: Appearance.colors.colPrimary
                x: root.horizontal ? index * slot + 2 : (root.edge === "left" ? 0 : strip.width - width)
                y: root.horizontal ? (root.edge === "top" ? 0 : strip.height - height) : index * slot + 2
                Behavior on len { NumberAnimation { duration: 70 } }
            }
        }
    }
}
