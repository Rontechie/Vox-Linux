import QtQuick

TextFieldRow {
    id: root

    property var obj
    property string key

    value: obj ? String(obj[key] ?? "") : ""
    onEditingFinished: v => {
        if (obj)
            obj[key] = v;
    }
}
