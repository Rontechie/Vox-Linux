import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.modules.nexus.compat
import qs.modules.nexus.components
import qs.modules.nexus.services
import qs.modules.nexus.utils
import qs.modules.nexus.common
import qs.modules.nexus.pages.about

PageBase {
    id: root

    readonly property int pluginCount: 0

    property string quickshellVersion
    property string hydroVersion

    title: Tr.tr("About")

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        Process {
            running: true
            command: ["quickshell", "--version"]
            stdout: StdioCollector {
                onStreamFinished: root.quickshellVersion = text.trim().split(" ")[1] ?? ""
            }
        }

        Process {
            running: true
            command: ["sh", "-c", "git -C \"$1\" describe --tags --always 2>/dev/null || true", "sh", Quickshell.shellPath(".")]
            stdout: StdioCollector {
                onStreamFinished: root.hydroVersion = text.trim()
            }
        }

        SystemUpdater {
            id: updater
        }

        AboutHero {
            Layout.fillWidth: true
            Layout.preferredHeight: 340
            Layout.bottomMargin: Tokens.spacing.small
            title: "Hydro"
            subtitle: root.hydroVersion ? Tr.tr("Version %1").replace("%1", root.hydroVersion) : (SysInfo.osPrettyName || SysInfo.osName)
            badge: updater.status === SystemUpdater.Available ? Tr.tr("Update available") : ""
            energy: updater.status === SystemUpdater.Updating ? 2.2 : (updater.status === SystemUpdater.Checking ? 1.6 : 1)
        }

        SectionHeader {
            text: Tr.tr("Software update")
        }

        UpdateCard {
            updater: updater
        }

        SectionHeader {
            text: Tr.tr("System")
        }

        InfoRow {
            first: true
            label: Tr.tr("Hostname")
            value: SysInfo.hostname
        }

        InfoRow {
            label: Tr.trCtx("Device", "system model name")
            value: SysInfo.device
        }

        InfoRow {
            label: Tr.tr("Distro")
            value: SysInfo.osPrettyName || SysInfo.osName
        }

        InfoRow {
            label: Tr.tr("Kernel")
            value: SysInfo.kernel
        }

        InfoRow {
            last: true
            label: Tr.tr("Firmware")
            value: SysInfo.firmware
        }

        SectionHeader {
            text: Tr.tr("Software")
        }

        InfoRow {
            first: true
            label: Tr.trCtx("Shell", "the Hydro shell itself, not a unix shell")
            value: root.hydroVersion || "Hydro"
        }

        InfoRow {
            label: "Quickshell"
            value: root.quickshellVersion || "…"
        }

        InfoRow {
            last: true
            label: "Qt"
            value: Qt.version || "…"
        }

        SectionHeader {
            text: Tr.tr("Plugins")
        }

        InfoRow {
            first: true
            last: true
            label: Tr.tr("Loaded plugins")
            value: root.pluginCount.toString()
        }
    }
}
