import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

NxRow {
    id: root
    property string icon: ""
    property string text: ""
    property string subtext: ""
    property string pill: ""
    property bool busy: false
    property bool accent: false
    RowLayout {
        Layout.fillWidth: true
        spacing: 14
        NxLabelBlock { icon: root.icon; text: root.text; subtext: root.subtext }
        MaterialSymbol {
            visible: root.busy
            text: "progress_activity"; iconSize: 20; color: Appearance.colors.colPrimary
            RotationAnimator on rotation { running: root.busy; from: 0; to: 360; duration: 900; loops: Animation.Infinite }
        }
        Rectangle {
            visible: root.pill.length > 0
            implicitHeight: 32
            implicitWidth: pillText.implicitWidth + 28
            radius: 16
            color: root.accent ? Appearance.colors.colPrimary : Appearance.colors.colSecondaryContainer
            StyledText {
                id: pillText
                anchors.centerIn: parent
                text: root.pill
                font.pixelSize: Appearance.font.pixelSize.small
                color: root.accent ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSecondaryContainer
            }
        }
    }
}
