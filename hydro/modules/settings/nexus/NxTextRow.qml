import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

NxRow {
    id: root
    property string icon: ""
    property string text: ""
    property string subtext: ""
    property string value: ""
    property string placeholder: ""
    property bool wide: false           // field below the label instead of beside it
    signal edited(string v)
    clickable: false

    GridLayout {
        Layout.fillWidth: true
        columns: root.wide ? 1 : 2
        columnSpacing: 14
        rowSpacing: 8
        NxLabelBlock { icon: root.icon; text: root.text; subtext: root.subtext }
        Rectangle {
            Layout.fillWidth: root.wide
            Layout.preferredWidth: root.wide ? -1 : 230
            implicitHeight: 40
            radius: 14
            color: Appearance.colors.colSurfaceContainerHighest
            border.width: field.activeFocus ? 2 : 0
            border.color: Appearance.colors.colPrimary
            TextInput {
                id: field
                anchors { fill: parent; leftMargin: 14; rightMargin: 14 }
                verticalAlignment: TextInput.AlignVCenter
                clip: true
                selectByMouse: true
                color: Appearance.m3colors.m3onSurface
                font.pixelSize: Appearance.font.pixelSize.small
                onEditingFinished: root.edited(text)
                Binding { target: field; property: "text"; value: root.value; when: !field.activeFocus }
                StyledText {
                    visible: field.text.length === 0 && !field.activeFocus
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.placeholder
                    color: Appearance.m3colors.m3outline
                    font.pixelSize: Appearance.font.pixelSize.small
                }
            }
        }
    }
}
