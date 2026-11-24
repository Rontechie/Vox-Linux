import qs.modules.common
import QtQuick

Item {
    id: root
    property real s: 250
    property real minutes: 0
    property string style: "medium"
    property color color: "white"
    readonly property real k: s / 250

    visible: style !== "hide"
    rotation: minutes * 6

    Rectangle {
        readonly property real w: (({ "classic": 9, "thin": 3, "medium": 5, "bold": 12 })[root.style] ?? 5) * root.k
        x: root.s / 2 - width / 2
        y: root.s / 2 - height + 8 * root.k
        width: w
        height: root.s * 0.36
        radius: width / 2
        color: root.color
    }
}
