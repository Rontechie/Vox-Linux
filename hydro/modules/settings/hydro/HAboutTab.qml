import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.modules.common
import qs.services
import qs.modules.common.widgets
import qs.modules.common.widgets.settings

GridPage {
    id: settingsGrid
    SettingsCard {
        Layout.columnSpan: settingsGrid.span(2)
        Item {
            Layout.fillWidth: true
            implicitHeight: 120

            RowLayout {
                anchors.centerIn: parent
                spacing: SettingsTheme.spacingL
                Image {
                    source: "file://" + Quickshell.shellPath("assets/images/hydro-logo.svg")
                    sourceSize: Qt.size(96, 96)
                    Layout.preferredWidth: 96
                    Layout.preferredHeight: 96
                }
                ColumnLayout {
                    spacing: 2
                    StyledText {
                        text: "hydro"
                        font.family: Appearance.font.family.expressive
                        font.pixelSize: 34
                        font.weight: Font.Bold
                        color: SettingsTheme.surfaceText
                    }
                    StyledText {
                        text: "a Quickshell desktop for Hyprland"
                        font.pixelSize: SettingsTheme.fontSizeSmall
                        color: SettingsTheme.surfaceVariantText
                    }
                }
            }
        }
    }

    SettingsCard {
        title: Translation.tr("Credits")
        iconName: "favorite"

        StyledText {
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
            font.pixelSize: SettingsTheme.fontSizeMedium
            color: SettingsTheme.surfaceText
            text: "Shell, services and most modules are from end-4's dots-hyprland (GPL-3.0).\n\nSettings layout and components are adapted from DankMaterialShell (MIT).\n\nSee THIRD_PARTY.md."
        }
    }
}
