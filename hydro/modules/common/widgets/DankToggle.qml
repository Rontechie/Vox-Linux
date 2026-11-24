import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property string text: ""
    property string description: ""
    property bool checked: false
    property bool hideText: false
    signal toggled(bool checked)

    implicitWidth: 300
    implicitHeight: Math.max(48, labels.implicitHeight + 24)
    opacity: enabled ? 1 : 0.4

    Rectangle {
        anchors.fill: parent
        radius: Appearance.rounding.normal
        color: Qt.rgba(Appearance.colors.colPrimary.r, Appearance.colors.colPrimary.g, Appearance.colors.colPrimary.b, hover.hovered && root.enabled ? 0.06 : 0)
        Behavior on color { ColorAnimation { duration: 150 } }
    }
    HoverHandler { id: hover }
    TapHandler { enabled: root.enabled; onTapped: sw.toggle() }

    RowLayout {
        anchors { fill: parent; leftMargin: 12; rightMargin: 12 }
        spacing: 12

        ColumnLayout {
            id: labels
            visible: !root.hideText
            Layout.fillWidth: true
            spacing: 2
            StyledText {
                Layout.fillWidth: true
                text: root.text
                font.weight: Font.Medium
                color: Appearance.colors.colOnLayer1
                wrapMode: Text.WordWrap
            }
            StyledText {
                visible: root.description !== ""
                Layout.fillWidth: true
                text: root.description
                font.pixelSize: Appearance.font.pixelSize.smaller
                color: Appearance.colors.colSubtext
                wrapMode: Text.WordWrap
            }
        }
        Item { visible: root.hideText; Layout.fillWidth: true }

        StyledSwitch {
            id: sw
            enabled: root.enabled
            checked: root.checked
            onToggled: {
                root.toggled(sw.checked)
                sw.checked = Qt.binding(() => root.checked)
            }
        }
    }
}
