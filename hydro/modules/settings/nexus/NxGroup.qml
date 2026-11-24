import QtQuick
import QtQuick.Layouts

ColumnLayout {
    id: root
    Layout.fillWidth: true
    spacing: 2

    function refresh() {
        const vis = [];
        for (let i = 0; i < children.length; i++) {
            const c = children[i];
            if (c.visible && c.first !== undefined && c.last !== undefined) vis.push(c);
        }
        for (let i = 0; i < vis.length; i++) {
            vis[i].first = i === 0;
            vis[i].last = i === vis.length - 1;
        }
    }
    onChildrenChanged: Qt.callLater(refresh)
    Component.onCompleted: refresh()
    Timer { interval: 400; running: true; repeat: true; onTriggered: root.refresh() }
}
