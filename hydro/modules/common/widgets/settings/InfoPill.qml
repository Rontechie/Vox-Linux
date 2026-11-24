import QtQuick
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    property string text: ""
    property color tint: Appearance.colors.colOnPrimaryContainer

    implicitHeight: 28
    implicitWidth: label.implicitWidth + 24
    radius: height / 2
    color: SettingsTheme.withAlpha(tint, 0.14)

    StyledText {
        id: label
        anchors.centerIn: parent
        text: root.text
        font.pixelSize: SettingsTheme.fontSizeSmall
        font.weight: Font.Medium
        color: root.tint
    }
}
