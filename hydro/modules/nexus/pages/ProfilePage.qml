pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.modules.common as HC
import qs.modules.common.widgets as HW
import qs.services as HS
import qs.modules.nexus.compat
import qs.modules.nexus.components
import qs.modules.nexus.services
import qs.modules.nexus.common

PageBase {
    id: root

    readonly property string custom: HC.Config.options.profile.avatarPath

    title: Tr.tr("Profile")

    readonly property Connections picked: Connections {
        target: root.nState

        function onFilePicked(tag: string, path: string): void {
            if (tag === "avatar")
                HC.Config.options.profile.avatarPath = path;
        }
    }

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        Item {
            Layout.fillWidth: true
            implicitHeight: 200

            ColumnLayout {
                anchors.centerIn: parent
                spacing: Tokens.spacing.medium

                HW.ProfileAvatar {
                    Layout.alignment: Qt.AlignHCenter
                    size: 120
                    ringWidth: 3
                    ringColor: Colours.palette.m3primary
                }
                StyledText {
                    Layout.alignment: Qt.AlignHCenter
                    text: HS.SystemInfo.username
                    font: Tokens.font.title.small
                }
            }
        }

        SectionHeader {
            first: true
            text: Tr.tr("Picture")
        }

        RowGroup {
            RowButton {
                icon: "photo_camera"
                text: Tr.tr("Choose a picture")
                subtext: Tr.tr("Used on the dashboard and in Settings")
                trailingIcon: "chevron_right"
                onClicked: root.nState.pickFile("avatar", Tr.tr("Choose a profile picture"))
            }
            RowButton {
                visible: root.custom.length > 0
                icon: "restart_alt"
                text: Tr.tr("Use system picture")
                subtext: Tr.tr("~/.face or your account picture")
                onClicked: HC.Config.options.profile.avatarPath = ""
            }
            InfoRow {
                icon: "image"
                label: Tr.tr("Source")
                value: root.custom.length > 0 ? root.custom : Tr.tr("~/.face, ~/.face.icon or account picture")
            }
        }
    }
}
