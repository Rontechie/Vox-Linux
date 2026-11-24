import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxRow {
    id: root
    property string icon: "key"
    property string text: ""
    property string placeholder: ""
    property string value: ""
    property bool reveal: false
    signal edited(string v)
    signal accepted(string v)
    clickable: false

    ColumnLayout {
        Layout.fillWidth: true
        spacing: 8
        NxLabelBlock { icon: root.icon; text: root.text }
        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 40
            radius: 14
            color: Appearance.colors.colSurfaceContainerHighest
            border.width: field.activeFocus ? 2 : 0
            border.color: Appearance.colors.colPrimary
            TextInput {
                id: field
                anchors { fill: parent; leftMargin: 14; rightMargin: 46 }
                verticalAlignment: TextInput.AlignVCenter
                clip: true
                selectByMouse: true
                echoMode: root.reveal ? TextInput.Normal : TextInput.Password
                color: Appearance.m3colors.m3onSurface
                font.pixelSize: Appearance.font.pixelSize.small
                onTextChanged: root.edited(text)
                onAccepted: root.accepted(text)
                Binding { target: field; property: "text"; value: root.value; when: !field.activeFocus }
                StyledText {
                    visible: field.text.length === 0 && !field.activeFocus
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.placeholder
                    color: Appearance.m3colors.m3outline
                    font.pixelSize: Appearance.font.pixelSize.small
                }
            }
            MaterialSymbol {
                anchors { right: parent.right; rightMargin: 12; verticalCenter: parent.verticalCenter }
                text: root.reveal ? "visibility_off" : "visibility"
                iconSize: 20
                color: Appearance.m3colors.m3onSurfaceVariant
                MouseArea { anchors { fill: parent; margins: -6 } cursorShape: Qt.PointingHandCursor; onClicked: root.reveal = !root.reveal }
            }
        }
    }
}
