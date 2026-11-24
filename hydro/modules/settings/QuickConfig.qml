import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.modules.common.widgets.settings

GridPage {
    id: settingsGrid
    forceWidth: true

    Process {
        id: randomWallProc
        property string status: ""
        property string scriptPath: `${Directories.scriptPath}/colors/random/random_konachan_wall.sh`
        command: ["bash", FileUtils.trimFileProtocol(randomWallProc.scriptPath)]
        stdout: SplitParser {
            onRead: data => {
                randomWallProc.status = data.trim();
            }
        }
    }

    ContentSection {
        Layout.columnSpan: settingsGrid.span(2)
        icon: "wallpaper"
        title: Translation.tr("Wallpaper")

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: SettingsTheme.spacingM
            Layout.rightMargin: SettingsTheme.spacingM
            Layout.bottomMargin: SettingsTheme.spacingS
            spacing: 20

            Item {
                id: previewBox
                Layout.alignment: Qt.AlignTop
                implicitWidth: 300
                implicitHeight: 180
                readonly property string path: Config.options.background.wallpaperPath
                readonly property real r: SettingsTheme.cornerRadius + 2

                StyledImage {
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectCrop
                    source: previewBox.path.length > 0 ? previewBox.path : Qt.resolvedUrl(Directories.assetsPath + "/images/default_wallpaper.png")
                    cache: false
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: Rectangle { width: previewBox.width; height: previewBox.height; radius: previewBox.r }
                    }
                }
                Rectangle { // hairline frame
                    anchors.fill: parent
                    radius: previewBox.r
                    color: "transparent"
                    border.width: 1
                    border.color: SettingsTheme.outline
                }
                Rectangle { // hover: change
                    anchors.fill: parent
                    radius: previewBox.r
                    color: SettingsTheme.withAlpha("#000000", previewHover.hovered ? 0.45 : 0)
                    Behavior on color { ColorAnimation { duration: 150 } }
                    Row {
                        anchors.centerIn: parent
                        spacing: 8
                        opacity: previewHover.hovered ? 1 : 0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                        MaterialSymbol { text: "folder_open"; iconSize: 20; color: "white"; anchors.verticalCenter: parent.verticalCenter }
                        StyledText { text: Translation.tr("Change"); color: "white"; font.pixelSize: SettingsTheme.fontSizeMedium; anchors.verticalCenter: parent.verticalCenter }
                    }
                    HoverHandler { id: previewHover; cursorShape: Qt.PointingHandCursor }
                    TapHandler { onTapped: Quickshell.execDetached(["bash", Directories.wallpaperSwitchScriptPath]) }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                spacing: 8

                ContentSubsectionLabel { text: Translation.tr("Source"); Layout.leftMargin: 0; Layout.topMargin: 0 }
                ExpressiveButton {
                    icon: "folder_open"
                    label: Translation.tr("Choose file")
                    onClicked: Quickshell.execDetached(["bash", Directories.wallpaperSwitchScriptPath])
                }
                ExpressiveButton {
                    visible: Config.options.policies.weeb === 1
                    enabled: !randomWallProc.running
                    busy: randomWallProc.running && randomWallProc.scriptPath.indexOf("konachan") >= 0
                    icon: "casino"
                    label: "Konachan"
                    onClicked: {
                        randomWallProc.scriptPath = `${Directories.scriptPath}/colors/random/random_konachan_wall.sh`;
                        randomWallProc.running = true;
                    }
                }
                ExpressiveButton {
                    visible: Config.options.policies.weeb === 1
                    enabled: !randomWallProc.running
                    busy: randomWallProc.running && randomWallProc.scriptPath.indexOf("osu") >= 0
                    icon: "casino"
                    label: "osu!"
                    onClicked: {
                        randomWallProc.scriptPath = `${Directories.scriptPath}/colors/random/random_osu_wall.sh`;
                        randomWallProc.running = true;
                    }
                }
            }
        }
    }

    ContentSection {
        icon: "palette"
        title: Translation.tr("Theme")

        SettingsSegmentedRow {
            text: Translation.tr("Color mode")
            options: [
                { displayName: Translation.tr("Light"), icon: "light_mode", value: "light" },
                { displayName: Translation.tr("Dark"), icon: "dark_mode", value: "dark" }
            ]
            currentValue: Appearance.m3colors.darkmode ? "dark" : "light"
            onSelected: v => Quickshell.execDetached(["bash", Directories.wallpaperSwitchScriptPath, "--mode", v, "--noswitch"])
        }
        SettingsDivider {}
        SettingsChipRow {
            text: Translation.tr("Palette")
            description: Translation.tr("How colors are derived from the wallpaper")
            options: [
                { value: "auto", displayName: "Auto" },
                { value: "scheme-content", displayName: "Content" },
                { value: "scheme-expressive", displayName: "Expressive" },
                { value: "scheme-fidelity", displayName: "Fidelity" },
                { value: "scheme-fruit-salad", displayName: "Fruit Salad" },
                { value: "scheme-monochrome", displayName: "Monochrome" },
                { value: "scheme-neutral", displayName: "Neutral" },
                { value: "scheme-rainbow", displayName: "Rainbow" },
                { value: "scheme-tonal-spot", displayName: "Tonal Spot" }
            ]
            currentValue: Config.options.appearance.palette.type
            onSelected: v => {
                Config.options.appearance.palette.type = v;
                Quickshell.execDetached(["bash", Directories.wallpaperSwitchScriptPath, "--noswitch"]);
            }
        }
        SettingsDivider {}
        SettingsToggleRow {
            text: Translation.tr("Transparency")
            description: Translation.tr("See-through panels and bar")
            checked: Config.options.appearance.transparency.enable
            onToggled: c => Config.options.appearance.transparency.enable = c
        }
    }

    ContentSection {
        icon: "screenshot_monitor"
        title: Translation.tr("Bar & screen")

        SettingsSegmentedRow {
            text: Translation.tr("Bar position")
            options: [
                { displayName: Translation.tr("Top"), icon: "arrow_upward", value: 0 },
                { displayName: Translation.tr("Left"), icon: "arrow_back", value: 2 },
                { displayName: Translation.tr("Bottom"), icon: "arrow_downward", value: 1 },
                { displayName: Translation.tr("Right"), icon: "arrow_forward", value: 3 }
            ]
            currentValue: (Config.options.bar.bottom ? 1 : 0) | (Config.options.bar.vertical ? 2 : 0)
            onSelected: v => {
                Config.options.bar.bottom = (v & 1) !== 0;
                Config.options.bar.vertical = (v & 2) !== 0;
            }
        }
        SettingsDivider {}
        SettingsSegmentedRow {
            text: Translation.tr("Bar style")
            options: [
                { displayName: Translation.tr("Hug"), icon: "line_curve", value: 0 },
                { displayName: Translation.tr("Float"), icon: "page_header", value: 1 },
                { displayName: Translation.tr("Rect"), icon: "toolbar", value: 2 }
            ]
            currentValue: Config.options.bar.cornerStyle
            onSelected: v => Config.options.bar.cornerStyle = v
        }
        SettingsDivider {}
        SettingsSegmentedRow {
            text: Translation.tr("Screen round corner")
            options: [
                { displayName: Translation.tr("No"), icon: "close", value: 0 },
                { displayName: Translation.tr("Yes"), icon: "check", value: 1 },
                { displayName: Translation.tr("Not fullscreen"), icon: "fullscreen_exit", value: 2 }
            ]
            currentValue: Config.options.appearance.fakeScreenRounding
            onSelected: v => Config.options.appearance.fakeScreenRounding = v
        }
    }

    NoticeBox {
        Layout.columnSpan: settingsGrid.fullSpan
        Layout.fillWidth: true
        text: Translation.tr('Not all options are available in this app. You should also check the config file by hitting the "Config file" button on the topleft corner or opening %1 manually.').arg(Directories.shellConfigPath)

        Item {
            Layout.fillWidth: true
        }
        RippleButtonWithIcon {
            id: copyPathButton
            property bool justCopied: false
            Layout.fillWidth: false
            buttonRadius: Appearance.rounding.small
            materialIcon: justCopied ? "check" : "content_copy"
            mainText: justCopied ? Translation.tr("Path copied") : Translation.tr("Copy path")
            onClicked: {
                copyPathButton.justCopied = true
                Quickshell.clipboardText = FileUtils.trimFileProtocol(`${Directories.config}/hydro/config.json`);
                revertTextTimer.restart();
            }
            colBackground: ColorUtils.transparentize(Appearance.colors.colPrimaryContainer)
            colBackgroundHover: Appearance.colors.colPrimaryContainerHover
            colRipple: Appearance.colors.colPrimaryContainerActive

            Timer {
                id: revertTextTimer
                interval: 1500
                onTriggered: {
                    copyPathButton.justCopied = false
                }
            }
        }
    }
}
