import QtQuick
import QtQuick.Layouts
import qs.modules.nexus.compat
import qs.modules.nexus.components
import qs.modules.nexus.components.controls
import qs.modules.nexus.services
import qs.modules.nexus
import qs.modules.nexus.navpane
import qs.modules.common.widgets as HW
import qs.services as HS

ColumnLayout {
    id: root

    required property NexusState nState

    spacing: Tokens.spacing.large

    StyledRect {
        id: profileCard

        readonly property int profileIdx: PageRegistry.pages.findIndex(p => p.label === Tr.tr("Profile"))

        Layout.fillWidth: true
        implicitHeight: 72
        radius: Tokens.rounding.extraLarge
        color: Colours.tPalette.m3surfaceContainerHigh

        StateLayer {
            radius: profileCard.radius
            onClicked: root.nState.currentPageIdx = profileCard.profileIdx
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Tokens.padding.large
            anchors.rightMargin: Tokens.padding.largeIncreased
            spacing: Tokens.spacing.medium

            HW.ProfileAvatar {
                Layout.alignment: Qt.AlignVCenter
                size: 48
            }
            Column {
                Layout.fillWidth: true
                spacing: 0

                StyledText {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    text: HS.SystemInfo.username
                    font: Tokens.font.body.medium
                    elide: Text.ElideRight
                }
                StyledText {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    text: Tr.tr("Change profile picture")
                    color: Colours.palette.m3outline
                    font: Tokens.font.label.small
                    elide: Text.ElideRight
                }
            }
            MaterialIcon {
                text: "chevron_right"
                color: Colours.palette.m3onSurfaceVariant
                fontStyle: Tokens.font.icon.medium
            }
        }
    }

    SearchBar {
        id: searchField

        Layout.fillWidth: true

        placeholderText: Tr.tr("Search settings")
        font: Tokens.font.body.large

        bg.color: Colours.tPalette.m3surfaceContainerLowest
        bg.border.color: Colours.palette.m3outlineVariant
        searchIcon.fontStyle: Tokens.font.icon.medium
        searchIcon.anchors.leftMargin: Tokens.padding.largeIncreased
        clearIcon.font: Tokens.font.icon.medium
        clearIcon.padding: Tokens.padding.extraSmall

        Behavior on bg.border.color {
            CAnim {}
        }

        Binding {
            target: root.nState
            property: "searchOpen"
            value: searchField.text.length > 0
        }
    }

    NavLocations {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.topMargin: -topMargin
        Layout.bottomMargin: -bottomMargin
        nState: root.nState
    }
}
