import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    id: page
    readonly property string appId: params?.id ?? ""
    readonly property var app: DesktopEntries.applications.values.find(a => a.id === appId) ?? null
    readonly property bool pinned: Config.options.launcher.pinnedApps.indexOf(appId) >= 0

    onAppChanged: if (!app && appId !== "") NxNav.pop()

    RowLayout {
        Layout.fillWidth: true
        Layout.leftMargin: 8
        Layout.bottomMargin: 8
        spacing: 18
        IconImage {
            asynchronous: true
            implicitSize: 64
            source: Quickshell.iconPath(page.app?.icon ?? "", "image-missing")
        }
        ColumnLayout {
            Layout.fillWidth: true
            spacing: 2
            StyledText {
                Layout.fillWidth: true
                text: page.app?.name ?? ""
                wrapMode: Text.WordWrap
                font.family: Appearance.font.family.expressive
                font.pixelSize: Appearance.font.pixelSize.larger
                color: Appearance.m3colors.m3onSurface
            }
            StyledText {
                Layout.fillWidth: true
                visible: text.length > 0
                text: (page.app?.comment || page.app?.genericName) ?? ""
                wrapMode: Text.WordWrap
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.m3colors.m3outline
            }
        }
    }

    NxGroup {
        NxButtonRow {
            icon: "play_arrow"; text: Translation.tr("Open")
            onClicked: { if (page.app) page.app.execute() }
        }
    }

    NxHeader { text: Translation.tr("Launcher") }
    NxGroup {
        NxToggleRow {
            icon: "keep"; text: Translation.tr("Pinned"); subtext: Translation.tr("Show in the launcher's pinned apps")
            checked: page.pinned
            onToggled: v => { if (v !== page.pinned) LauncherApps.togglePin(page.appId) }
        }
    }

    NxHeader { text: Translation.tr("Details") }
    NxGroup {
        NxInfoRow { icon: "badge"; text: Translation.tr("App ID"); value: page.appId }
        NxInfoRow { icon: "terminal"; text: Translation.tr("Command"); value: (page.app?.command ?? []).join(" ") }
        NxInfoRow { visible: (page.app?.categories ?? []).length > 0; icon: "category"; text: Translation.tr("Categories"); value: (page.app?.categories ?? []).join(", ") }
    }
}
