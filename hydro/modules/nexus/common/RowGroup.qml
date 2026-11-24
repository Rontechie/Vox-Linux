import QtQuick
import QtQuick.Layouts
import qs.modules.nexus.compat

ColumnLayout {
    id: root

    function relayout(): void {
        const rows = [];
        for (let i = 0; i < children.length; i++) {
            const c = children[i];
            if (c.visible && c.first !== undefined && c.last !== undefined)
                rows.push(c);
        }
        rows.forEach((c, i) => {
            c.first = i === 0;
            c.last = i === rows.length - 1;
        });
    }

    Layout.fillWidth: true
    spacing: Tokens.spacing.extraSmall / 2

    Component.onCompleted: relayout()
    onChildrenChanged: relayout()
}
