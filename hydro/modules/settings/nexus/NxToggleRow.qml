import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

NxRow {
    id: root
    property string icon: ""
    property string text: ""
    property string subtext: ""
    property bool checked: false
    signal toggled(bool value)
    onClicked: toggled(!checked)

    RowLayout {
        Layout.fillWidth: true
        spacing: 14
        NxLabelBlock { icon: root.icon; text: root.text; subtext: root.subtext }
        StyledSwitch {
            id: sw
            enabled: !root.disabled
            onToggled: root.toggled(checked)
            Binding { target: sw; property: "checked"; value: root.checked }
        }
    }
}
