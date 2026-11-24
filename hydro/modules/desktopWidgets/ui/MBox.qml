import QtQuick
import qs.modules.common.widgets

Item {
    id: box
    property string from: "Circle"
    property string to: ""
    property real t: 0
    property color fill: "white"
    readonly property bool morphing: to !== "" && to !== from

    function shapeFor(name) {
        const v = MaterialShape.Shape[name];
        return v === undefined ? MaterialShape.Shape.Circle : v;
    }

    MaterialShape {
        anchors.fill: parent
        implicitSize: Math.min(box.width, box.height)
        shape: box.shapeFor(box.from)
        color: box.fill
        opacity: box.morphing ? 1 - box.t : 1
    }
    MaterialShape {
        anchors.fill: parent
        visible: box.morphing
        implicitSize: Math.min(box.width, box.height)
        shape: box.shapeFor(box.to === "" ? box.from : box.to)
        color: box.fill
        opacity: box.t
    }
}
