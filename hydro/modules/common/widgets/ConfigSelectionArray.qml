import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    property var options: []
    property var currentValue: null
    property bool forceChips: false
    signal selected(var newValue)

    readonly property bool compact: !forceChips && options.length <= 4

    Layout.fillWidth: true
    implicitHeight: loader.item ? loader.item.implicitHeight : 0
    implicitWidth: loader.item ? loader.item.implicitWidth : 0

    Loader {
        id: loader
        width: root.width
        sourceComponent: root.compact ? segmented : chips
    }

    Component {
        id: segmented
        HSegmented {
            options: root.options
            currentValue: root.currentValue
            onSelected: v => root.selected(v)
        }
    }
    Component {
        id: chips
        Flow {
            width: root.width
            spacing: 8
            Repeater {
                model: root.options
                delegate: ExpressiveButton {
                    required property var modelData
                    tonal: false
                    icon: modelData.icon || ""
                    label: modelData.displayName
                    toggled: root.currentValue == modelData.value
                    onClicked: root.selected(modelData.value)
                }
            }
        }
    }
}
