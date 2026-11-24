import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

NxRow {
    id: root
    property string icon: ""
    property string text: ""
    property string subtext: ""
    property var model: []
    property var current
    property bool open: false
    signal picked(var value)
    readonly property string currentLabel: {
        const m = model.find(o => o.value === current);
        return m ? m.label : "";
    }
    onClicked: open = !open

    RowLayout {
        Layout.fillWidth: true
        spacing: 14
        NxLabelBlock { icon: root.icon; text: root.text; subtext: root.subtext }
        Rectangle {
            implicitHeight: 40
            implicitWidth: pillRow.implicitWidth + 32
            radius: root.open ? 12 : 20
            color: Appearance.colors.colSecondaryContainer
            Behavior on radius { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
            Row {
                id: pillRow
                anchors.centerIn: parent
                spacing: 8
                StyledText { anchors.verticalCenter: parent.verticalCenter; text: root.currentLabel; font.pixelSize: Appearance.font.pixelSize.small; color: Appearance.colors.colOnSecondaryContainer }
                MaterialSymbol {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "expand_more"; iconSize: 20; color: Appearance.colors.colOnSecondaryContainer
                    rotation: root.open ? 180 : 0
                    Behavior on rotation { NumberAnimation { duration: 250; easing.type: Easing.OutCubic } }
                }
            }
        }
    }
    Flow {
        id: opts
        Layout.fillWidth: true
        Layout.topMargin: root.open ? 8 : 0
        spacing: 6
        clip: true
        property real shownHeight: root.open ? opts.implicitHeight : 0
        Layout.preferredHeight: shownHeight
        opacity: root.open ? 1 : 0
        Behavior on shownHeight { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 160 } }
        Repeater {
            model: root.model
            Rectangle {
                required property var modelData
                readonly property bool sel: modelData.value === root.current
                height: 36
                width: optText.implicitWidth + 32
                radius: sel ? 12 : 18
                color: sel ? Appearance.colors.colPrimary : Appearance.colors.colSurfaceContainerHighest
                Behavior on radius { NumberAnimation { duration: 200 } }
                StyledText {
                    id: optText
                    anchors.centerIn: parent
                    text: parent.modelData.label
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: parent.sel ? Appearance.colors.colOnPrimary : Appearance.m3colors.m3onSurface
                }
                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: { root.picked(parent.modelData.value); root.open = false }
                }
            }
        }
    }
}
