import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    id: page
    readonly property string accent: Config.options.appearance.palette.accentColor
    readonly property var schemes: [
        { value: "auto", label: Translation.tr("Auto"), desc: Translation.tr("Picked from the wallpaper"), icon: "auto_awesome" },
        { value: "scheme-tonal-spot", label: "Tonal Spot", desc: Translation.tr("Calm, balanced Material default"), icon: "contrast" },
        { value: "scheme-expressive", label: "Expressive", desc: Translation.tr("Shifted hues, playful"), icon: "brush" },
        { value: "scheme-fidelity", label: "Fidelity", desc: Translation.tr("Stays close to the wallpaper"), icon: "image" },
        { value: "scheme-content", label: "Content", desc: Translation.tr("Like fidelity, content-driven"), icon: "article" },
        { value: "scheme-fruit-salad", label: "Fruit Salad", desc: Translation.tr("Bold and colourful"), icon: "nutrition" },
        { value: "scheme-rainbow", label: "Rainbow", desc: Translation.tr("Wide range of hues"), icon: "looks" },
        { value: "scheme-neutral", label: "Neutral", desc: Translation.tr("Barely any colour"), icon: "filter_b_and_w" },
        { value: "scheme-monochrome", label: "Monochrome", desc: Translation.tr("Greyscale"), icon: "monochrome_photos" }
    ]
    readonly property var swatches: ["#EF5350", "#EC407A", "#AB47BC", "#7E57C2", "#5C6BC0", "#42A5F5", "#26C6DA", "#26A69A", "#66BB6A", "#9CCC65", "#FFEE58", "#FFA726", "#8D6E63"]

    function switchwall(args) { Quickshell.execDetached(["bash", Directories.wallpaperSwitchScriptPath].concat(args)); }

    NxHeader { text: Translation.tr("Mode") }
    NxGroup {
        NxSelectRow {
            icon: "contrast"; text: Translation.tr("Light or dark")
            model: [{ value: "light", label: Translation.tr("Light") }, { value: "dark", label: Translation.tr("Dark") }]
            current: Appearance.m3colors.darkmode ? "dark" : "light"
            onPicked: v => page.switchwall(["--mode", v, "--noswitch"])
        }
    }

    NxHeader { text: Translation.tr("Scheme type") }
    NxGroup {
        Repeater {
            model: page.schemes
            NxButtonRow {
                required property var modelData
                readonly property bool active: Config.options.appearance.palette.type === modelData.value
                icon: modelData.icon; text: modelData.label; subtext: modelData.desc
                pill: active ? Translation.tr("In use") : ""
                accent: active
                onClicked: {
                    Config.options.appearance.palette.type = modelData.value;
                    page.switchwall(["--noswitch"]);
                }
            }
        }
    }

    NxHeader { text: Translation.tr("Accent colour") }
    NxGroup {
        NxRow {
            clickable: false
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 10
                NxLabelBlock {
                    icon: "colorize"; text: Translation.tr("Fixed accent")
                    subtext: page.accent.length > 0 ? page.accent : Translation.tr("Using wallpaper colours")
                }
                Flow {
                    Layout.fillWidth: true
                    spacing: 10
                    Repeater {
                        model: page.swatches
                        Rectangle {
                            id: sw
                            required property string modelData
                            readonly property bool sel: page.accent.toLowerCase() === modelData.toLowerCase()
                            width: 40; height: 40
                            radius: swMa.pressed ? 10 : sel ? 12 : 20
                            color: modelData
                            border.width: sel ? 3 : 0
                            border.color: Appearance.m3colors.m3onSurface
                            Behavior on radius { NumberAnimation { duration: 180; easing.type: Easing.OutCubic } }
                            MaterialSymbol {
                                visible: sw.sel
                                anchors.centerIn: parent
                                text: "check"; iconSize: 22; color: "#000000"
                            }
                            MouseArea {
                                id: swMa
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: page.switchwall(["--color", sw.modelData, "--noswitch"])
                            }
                        }
                    }
                }
            }
        }
        NxButtonRow {
            icon: "colorize"; text: Translation.tr("Pick from screen"); subtext: Translation.tr("Uses hyprpicker")
            onClicked: page.switchwall(["--color", "--noswitch"])
        }
        NxButtonRow {
            visible: page.accent.length > 0
            icon: "restart_alt"; text: Translation.tr("Use wallpaper colours")
            onClicked: page.switchwall(["--color", "clear", "--noswitch"])
        }
    }
}
