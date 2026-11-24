import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

StyledText {
    Layout.fillWidth: true
    Layout.topMargin: 18
    Layout.bottomMargin: 4
    Layout.leftMargin: 8
    color: Appearance.m3colors.m3onSurfaceVariant
    font.pixelSize: 14
    font.weight: Font.Medium
    elide: Text.ElideRight
}
