import QtQuick

QtObject {
    id: root

    property Item a
    property Item b
    property var transform: ({ "x": 0, "y": 0, "tick": 0 })

    readonly property Timer timer: Timer {
        interval: 33
        repeat: true
        running: root.a !== null && root.b !== null
        onTriggered: {
            const p = root.a && root.b ? root.a.mapToItem(root.b, 0, 0) : Qt.point(0, 0);
            const t = root.transform;
            if (p.x !== t.x || p.y !== t.y)
                root.transform = { "x": p.x, "y": p.y, "tick": t.tick + 1 };
        }
    }
}
