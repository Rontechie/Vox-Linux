import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

NxRow {
    id: root
    property string icon: ""
    property string label: ""
    property string valueLabel: ""
    property real value: 0
    property real from: 0
    property real to: 1
    property real stepSize: 0
    signal moved(real v)
    clickable: false
    vPadding: 14

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 4
        RowLayout {
            Layout.fillWidth: true
            spacing: 14
            NxLabelBlock { icon: root.icon; text: root.label }
            StyledText { text: root.valueLabel; color: Appearance.m3colors.m3onSurfaceVariant; font.family: Appearance.font.family.monospace; font.pixelSize: Appearance.font.pixelSize.small }
        }
        StyledSlider {
            id: slider
            Layout.fillWidth: true
            from: root.from
            to: root.to
            stepSize: root.stepSize
            enabled: !root.disabled
            onMoved: root.moved(value)
            Binding { target: slider; property: "value"; value: root.value; when: !slider.pressed }
        }
    }
}
