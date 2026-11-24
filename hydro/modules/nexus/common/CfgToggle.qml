import QtQuick

ToggleRow {
    id: root

    property var obj
    property string key

    checked: obj ? !!obj[key] : false
    onToggled: {
        if (obj)
            obj[key] = checked;
        checked = Qt.binding(() => root.obj ? !!root.obj[root.key] : false);
    }
}
