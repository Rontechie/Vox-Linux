import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import QtQuick.Layouts

ColumnLayout {
    id: r
    property var pal
    property string title
    property string desc
    property bool checked: false
    property string onText: "Enabled"
    property string offText: "Disabled"
    property bool divider: true
    signal toggled(bool v)
    default property alias extra: ex.data
    Layout.fillWidth: true
    spacing: 8
    RowLayout {
        Layout.fillWidth: true; spacing: 10
        ColumnLayout {
            Layout.fillWidth: true; spacing: 0
            StyledText { text: r.title; font.pixelSize: 13; font.bold: true; color: r.pal.fg }
            StyledText { text: r.checked ? r.onText : r.offText; font.pixelSize: 11; color: r.pal.onSurfaceVariant }
            StyledText { text: r.desc; visible: r.desc !== ""; font.pixelSize: 10; color: r.pal.onSurfaceVariant; opacity: 0.7
                wrapMode: Text.Wrap; Layout.fillWidth: true }
        }
        M3Switch { pal: r.pal; checked: r.checked; onToggled: v => r.toggled(v) }
    }
    ColumnLayout { id: ex; Layout.fillWidth: true; spacing: 0 }
    Rectangle { visible: r.divider; Layout.fillWidth: true; Layout.topMargin: 4; Layout.preferredHeight: 1; color: r.pal.containerHighest }
}
