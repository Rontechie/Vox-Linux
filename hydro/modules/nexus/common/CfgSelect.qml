import QtQuick
import QtQml
import qs.modules.nexus.components.controls

SelectRow {
    id: root

    property var obj
    property string key
    property var options: []

    readonly property Instantiator items: Instantiator {
        model: root.options

        MenuItem {
            required property var modelData

            text: modelData.text
            value: modelData.value
        }
    }

    menuItems: {
        const list = [];
        for (let i = 0; i < items.count; i++)
            list.push(items.objectAt(i));
        return list;
    }
    active: menuItems.find(i => i.value === (obj ? obj[key] : undefined)) ?? menuItems[0]
    onSelected: item => {
        if (obj)
            obj[key] = item.value;
    }
}
