import qs.modules.common
import QtQuick

Item {
    id: root
    property real s: 250
    property int seconds: 0
    property string style: "classic"
    property color color: "white"
    property color dotColor: color
    readonly property real k: s / 250

    visible: style !== "hide"

    property real goal: 0
    property bool ready: false
    property real shown: goal
    Behavior on shown {
        enabled: root.ready
        NumberAnimation { duration: 420; easing.type: Easing.OutBack; easing.overshoot: 2.2 }
    }
    Component.onCompleted: {
        goal = seconds * 6;
        ready = true;
    }
    onSecondsChanged: {
        const cur = ((goal % 360) + 360) % 360;
        goal += (((seconds * 6 - cur) % 360) + 360) % 360;
    }
    rotation: shown

    Rectangle { // rim bead
        visible: root.style === "dot"
        x: root.s / 2 - width / 2
        y: root.s * 0.075
        width: 11 * root.k; height: width; radius: width / 2
        color: root.dotColor
    }
    Rectangle { // line
        readonly property bool classic: root.style === "classic"
        visible: root.style === "line" || classic
        x: root.s / 2 - width / 2
        y: root.s / 2 - root.s * 0.36
        width: 3 * root.k
        height: root.s * 0.36 + (classic ? root.s * 0.09 : 0)
        radius: width / 2
        color: root.color
    }
    Rectangle { // bead on the line
        visible: root.style === "classic"
        x: root.s / 2 - width / 2
        y: root.s / 2 - root.s * 0.26 - height / 2
        width: 12 * root.k; height: width; radius: width / 2
        color: root.color
    }
}
