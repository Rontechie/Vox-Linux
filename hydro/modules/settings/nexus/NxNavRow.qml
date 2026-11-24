import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

NxRow {
    id: root
    property string icon: ""
    property string text: ""
    property string subtext: ""
    property string trailingIcon: "chevron_right"
    property string trailingText: ""
    RowLayout {
        Layout.fillWidth: true
        spacing: 14
        NxLabelBlock { icon: root.icon; text: root.text; subtext: root.subtext }
        StyledText {
            visible: root.trailingText.length > 0
            text: root.trailingText
            color: Appearance.m3colors.m3outline
            font.pixelSize: Appearance.font.pixelSize.small
        }
        MaterialSymbol { visible: root.trailingIcon.length > 0; text: root.trailingIcon; iconSize: 22; color: Appearance.m3colors.m3onSurfaceVariant }
    }
}
