import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxRow {
    id: root
    property var entry: null
    property bool pinned: false
    RowLayout {
        Layout.fillWidth: true
        spacing: 14
        IconImage {
            asynchronous: true
            implicitSize: 36
            source: Quickshell.iconPath(root.entry?.icon ?? "", "image-missing")
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0
            StyledText {
                Layout.fillWidth: true
                text: root.entry?.name ?? ""
                elide: Text.ElideRight
                font.pixelSize: Appearance.font.pixelSize.normal
                color: Appearance.m3colors.m3onSurface
            }
            StyledText {
                Layout.fillWidth: true
                visible: text.length > 0
                text: (root.entry?.comment || root.entry?.genericName) ?? ""
                elide: Text.ElideRight
                font.pixelSize: Appearance.font.pixelSize.smaller
                color: Appearance.m3colors.m3outline
            }
        }
        MaterialSymbol { visible: root.pinned; text: "keep"; fill: 1; iconSize: 20; color: Appearance.colors.colPrimary }
        MaterialSymbol { text: "chevron_right"; iconSize: 22; color: Appearance.m3colors.m3onSurfaceVariant }
    }
}
