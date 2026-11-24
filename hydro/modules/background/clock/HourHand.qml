import qs.modules.common
import QtQuick

Item {
    id: root
    property real s: 250
    property real hours: 0
    property string style: "fill"
    property color fillColor: "white"
    property color lineColor: "white"
    readonly property real k: s / 250

    visible: style !== "hide"
    rotation: hours * 30

    Rectangle {
        readonly property bool hollow: root.style === "hollow"
        readonly property bool classic: root.style === "classic"
        x: root.s / 2 - width / 2
        y: root.s / 2 - height + (classic ? 8 : 10) * root.k
        width: (classic ? 10 : 19) * root.k
        height: root.s * (classic ? 0.24 : 0.25)
        radius: width / 2
        color: hollow ? "transparent" : root.fillColor
        border.width: hollow ? 3 * root.k : 0
        border.color: root.lineColor
    }
}
