import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    id: page
    property string query: ""
    readonly property var apps: {
        const q = query.trim().toLowerCase();
        const all = [...DesktopEntries.applications.values];
        const pinned = Config.options.launcher.pinnedApps;
        return all
            .filter(a => q === "" || (a.name + " " + (a.genericName ?? "") + " " + (a.comment ?? "") + " " + a.id).toLowerCase().indexOf(q) >= 0)
            .sort((a, b) => ((pinned.indexOf(b.id) >= 0) - (pinned.indexOf(a.id) >= 0)) || a.name.localeCompare(b.name));
    }

    Rectangle {
        Layout.fillWidth: true
        implicitHeight: 48
        radius: 24
        color: Appearance.colors.colSurfaceContainerHigh
        border.width: searchField.activeFocus ? 2 : 1
        border.color: searchField.activeFocus ? Appearance.colors.colPrimary : Appearance.m3colors.m3outlineVariant
        RowLayout {
            anchors { fill: parent; leftMargin: 16; rightMargin: 12 }
            spacing: 10
            MaterialSymbol { text: "search"; iconSize: 22; color: Appearance.m3colors.m3onSurfaceVariant }
            TextInput {
                id: searchField
                Layout.fillWidth: true
                verticalAlignment: TextInput.AlignVCenter
                clip: true
                selectByMouse: true
                color: Appearance.m3colors.m3onSurface
                font.pixelSize: Appearance.font.pixelSize.normal
                onTextChanged: page.query = text
                StyledText {
                    visible: searchField.text.length === 0
                    anchors.verticalCenter: parent.verticalCenter
                    text: Translation.tr("Search apps")
                    color: Appearance.m3colors.m3outline
                    font.pixelSize: Appearance.font.pixelSize.normal
                }
            }
            MaterialSymbol {
                visible: searchField.text.length > 0
                text: "close"; iconSize: 20; color: Appearance.m3colors.m3onSurfaceVariant
                MouseArea { anchors { fill: parent; margins: -6 } cursorShape: Qt.PointingHandCursor; onClicked: searchField.text = "" }
            }
        }
    }

    NxHeader { text: Translation.tr("%1 apps").arg(page.apps.length) }
    NxGroup {
        Repeater {
            model: page.apps
            NaAppRow {
                required property var modelData
                entry: modelData
                pinned: Config.options.launcher.pinnedApps.indexOf(modelData.id) >= 0
                onClicked: NxNav.push(modelData.name, "modules/settings/nexus/apps/AppInfo.qml", { id: modelData.id })
            }
        }
        NxInfoRow { visible: page.apps.length === 0; icon: "search_off"; text: Translation.tr("No apps match"); value: "" }
    }
}
