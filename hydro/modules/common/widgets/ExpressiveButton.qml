import QtQuick
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    property string label
    property string icon: ""
    property bool toggled: false
    property bool busy: false
    property bool tonal: true // false = outlined
    signal clicked()

    implicitHeight: 40
    implicitWidth: row.implicitWidth + 32
    opacity: enabled ? 1 : 0.4
    scale: area.pressed ? 0.97 : 1
    Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }

    Rectangle {
        anchors.fill: parent
        radius: SettingsTheme.cornerRadius - 2
        color: root.toggled ? Appearance.colors.colPrimary
             : area.containsMouse ? SettingsTheme.withAlpha(Appearance.colors.colPrimary, 0.12)
             : root.tonal ? Appearance.colors.colLayer2 : "transparent"
        border.width: root.toggled ? 0 : 1
        border.color: root.tonal ? SettingsTheme.withAlpha(SettingsTheme.outline, 0.5) : SettingsTheme.outline
        Behavior on color { ColorAnimation { duration: 140 } }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 8
        MaterialSymbol {
            visible: root.icon.length > 0 || root.busy
            anchors.verticalCenter: parent.verticalCenter
            text: root.busy ? "progress_activity" : root.icon
            iconSize: 18
            color: root.toggled ? Appearance.colors.colOnPrimary : Appearance.colors.colSubtext
            RotationAnimator on rotation { running: root.busy; from: 0; to: 360; duration: 900; loops: Animation.Infinite }
        }
        StyledText {
            anchors.verticalCenter: parent.verticalCenter
            text: root.label
            font.pixelSize: SettingsTheme.fontSizeMedium
            font.weight: root.toggled ? Font.Medium : Font.Normal
            color: root.toggled ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1
        }
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: root.clicked()
    }
}
