import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.services
import qs.modules.common
import qs.modules.common.widgets

NxPage {
    id: page

    property string hostname: ""
    property string device: ""
    property string kernel: ""
    property string firmware: ""
    property string quickshellVersion: ""

    Process {
        running: true
        command: ["sh", "-c", "printf '%s\\n' \"$(hostname 2>/dev/null)\" \"$(cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null)\" \"$(uname -r)\" \"$(cat /sys/devices/virtual/dmi/id/bios_version 2>/dev/null)\" \"$(quickshell --version 2>/dev/null)\""]
        stdout: StdioCollector {
            onStreamFinished: {
                const l = text.split("\n");
                page.hostname = l[0] ?? "";
                page.device = l[1] ?? "";
                page.kernel = l[2] ?? "";
                page.firmware = l[3] ?? "";
                const m = (l[4] ?? "").match(/(\d+(?:\.\d+)+)/);
                page.quickshellVersion = m ? m[1] : (l[4] ?? "");
            }
        }
    }

    NxGroup {
        NxRow {
            clickable: false
            vPadding: 26
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    implicitWidth: 96; implicitHeight: 96
                    radius: 34
                    color: Appearance.colors.colPrimaryContainer
                    Image {
                        anchors.centerIn: parent
                        source: "file://" + Quickshell.shellPath("assets/images/hydro-logo.svg")
                        sourceSize: Qt.size(64, 64)
                        width: 64; height: 64
                        fillMode: Image.PreserveAspectFit
                    }
                }
                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 6
                    text: "Hydro"
                    font.family: Appearance.font.family.expressive
                    font.pixelSize: 34
                    font.weight: Font.Bold
                    color: Appearance.m3colors.m3onSurface
                }
                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: Translation.tr("A Quickshell desktop for Hyprland")
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: Appearance.m3colors.m3onSurfaceVariant
                }
            }
        }
    }

    NxHeader { text: Translation.tr("System") }
    NxGroup {
        NxInfoRow { icon: "badge"; text: Translation.tr("Hostname"); value: page.hostname || "…" }
        NxInfoRow { icon: "person"; text: Translation.tr("User"); value: SystemInfo.username }
        NxInfoRow { visible: page.device.length > 0; icon: "computer"; text: Translation.tr("Device"); value: page.device }
        NxInfoRow { icon: "deployed_code"; text: Translation.tr("Distro"); value: SystemInfo.distroName }
        NxInfoRow { icon: "memory"; text: Translation.tr("Kernel"); value: page.kernel || "…" }
        NxInfoRow { visible: page.firmware.length > 0; icon: "developer_board"; text: Translation.tr("Firmware"); value: page.firmware }
        NxInfoRow { visible: SystemInfo.desktopEnvironment.length > 0; icon: "desktop_windows"; text: Translation.tr("Desktop"); value: SystemInfo.desktopEnvironment }
    }

    NxHeader { text: Translation.tr("Software") }
    NxGroup {
        NxInfoRow { icon: "water_drop"; text: Translation.tr("Shell"); value: Translation.tr("Ported build") }
        NxInfoRow { icon: "terminal"; text: "Quickshell"; value: page.quickshellVersion || "…" }
        NxInfoRow { icon: "folder"; text: Translation.tr("Config file"); value: Directories.shellConfigPath }
    }

    NxHeader { text: Translation.tr("Credits") }
    NxGroup {
        NxButtonRow {
            icon: "favorite"; text: "end-4 / dots-hyprland"
            subtext: Translation.tr("Base shell, services and widgets (GPL-3.0)")
            onClicked: Qt.openUrlExternally("https://github.com/end-4/dots-hyprland")
        }
        NxButtonRow {
            icon: "favorite"; text: "Caelestia shell"
            subtext: Translation.tr("Nexus settings layout and design (GPL-3.0)")
            onClicked: Qt.openUrlExternally("https://github.com/caelestia-dots/shell")
        }
        NxButtonRow {
            icon: "favorite"; text: "DankMaterialShell"
            subtext: Translation.tr("Settings card and row design (MIT)")
            onClicked: Qt.openUrlExternally("https://github.com/AvengeMedia/DankMaterialShell")
        }
    }
    StyledText {
        Layout.fillWidth: true; Layout.topMargin: 8; Layout.leftMargin: 8
        wrapMode: Text.WordWrap
        text: Translation.tr("Hydro as a whole is GPL-3.0. See THIRD_PARTY.md for details.")
        font.pixelSize: Appearance.font.pixelSize.smaller
        color: Appearance.m3colors.m3outline
    }
}
