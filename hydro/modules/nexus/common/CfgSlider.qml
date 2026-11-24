import QtQuick

ValueSliderRow {
    id: root

    property var obj
    property string key

    value: obj ? Number(obj[key]) : from
    onMoved: v => {
        if (obj)
            obj[key] = v;
    }
}
