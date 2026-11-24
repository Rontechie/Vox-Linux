import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus
import qs.modules.common.functions

NxPage {
    id: page
    readonly property string custom: Config.options.profile.avatarPath

    Connections {
        target: NxNav
        function onFilePicked(tag, path) { if (tag === "avatar") Config.options.profile.avatarPath = path }
    }

    Item {
        Layout.fillWidth: true
        implicitHeight: 190
        ColumnLayout {
            anchors.centerIn: parent
            spacing: 10
            ProfileAvatar { Layout.alignment: Qt.AlignHCenter; size: 120; ringWidth: 3; ringColor: Appearance.colors.colPrimary }
            StyledText {
                Layout.alignment: Qt.AlignHCenter
                text: SystemInfo.username
                font.pixelSize: Appearance.font.pixelSize.larger
                font.weight: Font.Medium
                color: Appearance.m3colors.m3onSurface
            }
        }
    }

    NxHeader { text: Translation.tr("Picture") }
    NxGroup {
        NxButtonRow {
            icon: "photo_camera"; text: Translation.tr("Choose a picture"); subtext: Translation.tr("Used on the dashboard and in Settings")
            onClicked: NxNav.pickFile("avatar", Translation.tr("Choose a profile picture"))
        }
        NxButtonRow {
            visible: page.custom.length > 0
            icon: "restart_alt"; text: Translation.tr("Use system picture"); subtext: Translation.tr("~/.face or your account picture")
            onClicked: Config.options.profile.avatarPath = ""
        }
        NxInfoRow {
            icon: "image"; text: Translation.tr("Source")
            value: page.custom.length > 0 ? page.custom : Translation.tr("~/.face, ~/.face.icon or account picture")
        }
    }
}
