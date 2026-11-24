import QtQuick

Item {
    id: root

    property real spacing: 0
    property bool busy: false

    function morph(item: Item): real {
        return item && item.shapeMorphExpansion !== undefined ? item.shapeMorphExpansion : 0;
    }

    function relayout(): void {
        if (busy)
            return;
        busy = true;

        const kids = [];
        for (let i = 0; i < root.children.length; i++) {
            const c = root.children[i];
            if (c.visible && c.implicitWidth !== undefined && !c.toString().startsWith("QQuickRepeater"))
                kids.push(c);
        }
        const n = kids.length;
        if (n === 0) {
            busy = false;
            return;
        }

        const totalSpacing = (n - 1) * spacing;
        let reserved = 0, unreserved = 0, fillCount = 0, maxH = 0;
        for (const c of kids) {
            maxH = Math.max(maxH, c.implicitHeight);
            if (c.fillWidth === undefined)
                continue;
            if (c.fillWidth) {
                fillCount++;
                unreserved += c.implicitWidth;
            } else {
                reserved += c.implicitWidth;
            }
        }
        if (fillCount === 0)
            fillCount = 1;
        const perItem = (width - totalSpacing - reserved) / fillCount;

        let x = 0;
        for (let i = 0; i < n; i++) {
            const c = kids[i];
            let prev = i > 0 ? morph(kids[i - 1]) : 0;
            let next = i < n - 1 ? morph(kids[i + 1]) : 0;
            if (i > 1)
                prev /= 2;
            if (i < n - 2)
                next /= 2;
            const base = c.fillWidth ? perItem : c.implicitWidth;
            c.width = base + morph(c) - prev - next;
            c.height = maxH;
            c.x = x;
            c.y = 0;
            x += c.width + spacing;
        }

        implicitWidth = reserved + unreserved + totalSpacing;
        implicitHeight = maxH;
        busy = false;
    }

    onWidthChanged: relayout()
    onSpacingChanged: relayout()
    onChildrenChanged: relayout()

    Timer {
        interval: 16
        repeat: true
        running: root.visible
        onTriggered: root.relayout()
    }
}
