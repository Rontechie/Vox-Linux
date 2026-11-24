import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

NxPage {
    id: page
    readonly property string wp: Config.options.background.wallpaperPath
    function switchwall(args) { Quickshell.execDetached(["bash", Directories.wallpaperSwitchScriptPath].concat(args ?? [])) }

    Process {
        id: randomProc
        property string scriptPath
        command: ["bash", FileUtils.trimFileProtocol(randomProc.scriptPath)]
    }

    Item {
        Layout.fillWidth: true
        implicitHeight: 250
        Item {
            id: pv
            anchors.centerIn: parent
            width: Math.min(parent.width, 440); height: 250
            StyledImage {
                anchors.fill: parent
                fillMode: Image.PreserveAspectCrop
                source: page.wp.length > 0 ? page.wp : "file://" + Directories.assetsPath + "/images/default_wallpaper.png"
                cache: false
                layer.enabled: true
                layer.effect: OpacityMask { maskSource: Rectangle { width: pv.width; height: pv.height; radius: 28 } }
            }
            Rectangle {
                anchors.fill: parent; radius: 28; color: "transparent"
                border.width: 1; border.color: Appearance.m3colors.m3outlineVariant
            }
        }
    }

    NxHeader { text: Translation.tr("Wallpaper") }
    NxGroup {
        NxButtonRow { icon: "folder_open"; text: Translation.tr("Choose file"); subtext: Translation.tr("Pick an image from your files"); onClicked: page.switchwall([]) }
        NxButtonRow {
            visible: Config.options.policies.weeb === 1
            icon: "casino"; text: Translation.tr("Random: Konachan"); busy: randomProc.running && randomProc.scriptPath.indexOf("konachan") >= 0
            disabled: randomProc.running
            onClicked: { randomProc.scriptPath = `${Directories.scriptPath}/colors/random/random_konachan_wall.sh`; randomProc.running = true }
        }
        NxButtonRow {
            visible: Config.options.policies.weeb === 1
            icon: "casino"; text: Translation.tr("Random: osu! seasonal"); busy: randomProc.running && randomProc.scriptPath.indexOf("osu") >= 0
            disabled: randomProc.running
            onClicked: { randomProc.scriptPath = `${Directories.scriptPath}/colors/random/random_osu_wall.sh`; randomProc.running = true }
        }
    }

    NxHeader { text: Translation.tr("Colours") }
    NxGroup {
        NxSelectRow {
            icon: "contrast"; text: Translation.tr("Mode")
            model: [{ value: "light", label: Translation.tr("Light") }, { value: "dark", label: Translation.tr("Dark") }]
            current: Appearance.m3colors.darkmode ? "dark" : "light"
            onPicked: v => page.switchwall(["--mode", v, "--noswitch"])
        }
        NxSelectRow {
            icon: "palette"; text: Translation.tr("Colour scheme")
            model: [
                { value: "auto", label: "Auto" }, { value: "scheme-tonal-spot", label: "Tonal Spot" }, { value: "scheme-expressive", label: "Expressive" },
                { value: "scheme-fidelity", label: "Fidelity" }, { value: "scheme-fruit-salad", label: "Fruit Salad" }, { value: "scheme-rainbow", label: "Rainbow" },
                { value: "scheme-neutral", label: "Neutral" }, { value: "scheme-monochrome", label: "Monochrome" }, { value: "scheme-content", label: "Content" }
            ]
            current: Config.options.appearance.palette.type
            onPicked: v => { Config.options.appearance.palette.type = v; page.switchwall(["--noswitch"]) }
        }
        NxToggleRow {
            icon: "opacity"; text: Translation.tr("Transparency"); subtext: Translation.tr("Frosted panels and sidebars")
            checked: Config.options.appearance.transparency.enable
            onToggled: v => Config.options.appearance.transparency.enable = v
        }
    }

    NxHeader { text: Translation.tr("Fonts") }
    NxGroup {
        NxTextRow { icon: "text_fields"; text: Translation.tr("Interface"); value: Config.options.appearance.fonts.main; onEdited: v => Config.options.appearance.fonts.main = v }
        NxTextRow { icon: "title"; text: Translation.tr("Titles"); value: Config.options.appearance.fonts.title; onEdited: v => Config.options.appearance.fonts.title = v }
        NxTextRow { icon: "auto_awesome"; text: Translation.tr("Expressive"); value: Config.options.appearance.fonts.expressive; onEdited: v => Config.options.appearance.fonts.expressive = v }
        NxTextRow { icon: "terminal"; text: Translation.tr("Monospace"); value: Config.options.appearance.fonts.monospace; onEdited: v => Config.options.appearance.fonts.monospace = v }
    }
}
