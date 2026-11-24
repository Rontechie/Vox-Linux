import QtQuick

Item {
    id: sp
    property real target: 0
    property real value: 0
    property string token: "spatialDefault"
    property real eps: 0.002
    property bool _snap: false
    visible: false
    width: 0
    height: 0

    function snap(v) {
        _snap = true;
        value = v;
        _snap = false;
    }
    onTargetChanged: value = target
    Component.onCompleted: snap(target)

    Behavior on value {
        enabled: !sp._snap
        M3SpringAnim { token: sp.token; epsilon: sp.eps }
    }
}
