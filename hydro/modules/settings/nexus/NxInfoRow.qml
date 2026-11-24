import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

NxRow {
    id: root
    property string icon: ""
    property string text: ""
    property string value: ""
    clickable: false
    vPadding: 11
    RowLayout {
        Layout.fillWidth: true
        spacing: 14
        NxLabelBlock { icon: root.icon; text: root.text }
        StyledText {
            Layout.maximumWidth: root.width * 0.55
            text: root.value
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignRight
            color: Appearance.m3colors.m3onSurfaceVariant
            font.pixelSize: Appearance.font.pixelSize.small
        }
    }
}
