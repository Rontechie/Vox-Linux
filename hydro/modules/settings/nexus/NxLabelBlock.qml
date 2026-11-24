import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

RowLayout {
    id: root
    property string icon: ""
    property string text: ""
    property string subtext: ""
    property bool iconFill: true
    spacing: 12
    Layout.fillWidth: true
    MaterialSymbol {
        visible: root.icon.length > 0
        text: root.icon
        fill: root.iconFill ? 1 : 0
        iconSize: 24
        color: Appearance.m3colors.m3onSurfaceVariant
    }
    ColumnLayout {
        Layout.fillWidth: true
        spacing: 0
        StyledText {
            Layout.fillWidth: true
            text: root.text
            elide: Text.ElideRight
            font.pixelSize: Appearance.font.pixelSize.normal
            color: Appearance.m3colors.m3onSurface
        }
        StyledText {
            Layout.fillWidth: true
            visible: root.subtext.length > 0
            text: root.subtext
            elide: Text.ElideRight
            font.pixelSize: 12
            color: Appearance.m3colors.m3outline
        }
    }
}
