import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import QtQuick.Layouts
import QtQuick.Controls.Basic as QC

Item {
    id: sp
    property var pal
    property var cfg
    property int tab: 0
    signal back()
    signal rescan()
    signal clearRecent()
    signal assignShortcut()

    readonly property var titles: ["Layout", "Look", "System"]
    readonly property var subs: ["Adjust what the launcher shows.", "Adjust the launcher's look.", "Maintenance and defaults."]
    readonly property var tabGlyphs: ["apps", "palette", "settings"]
    readonly property var swatches: ["#c3cbb0", "#a8c8ff", "#ffb1c4", "#e9c16c"]
    readonly property var panelGlyphs: ["apps", "menu", "home", "star", "favorite", "widgets", "dashboard", "bolt", "eco"]
    readonly property var shapeList: ["circle", "square", "cookie9", "cookie12", "sunny", "flower", "clover4"]

    function resetAll() {
        const d = { cols: 1, iconSize: 1, sizeIdx: 1, showLabels: true, showFavs: true, showCats: true, showPower: true,
                    confirmPower: true, iconShape: 2, hoverMorph: true, panelIcon: 9, customIcon: "" }
        for (const k in d) cfg[k] = d[k]
    }

    RowLayout {
        anchors.fill: parent; anchors.margins: 12; spacing: 10

        Rectangle {
            Layout.fillHeight: true; Layout.preferredWidth: 52; radius: 26; color: sp.pal.container
            Column {
                anchors.horizontalCenter: parent.horizontalCenter; y: 8; spacing: 6
                GBtn { pal: sp.pal; glyph: "back"; sz: 40; onClicked: sp.back() }
                Rectangle { width: 24; height: 1; color: sp.pal.containerHighest; anchors.horizontalCenter: parent.horizontalCenter }
                Repeater {
                    model: 3
                    delegate: Item {
                        width: 40; height: 40
                        scale: tma.pressed ? 0.88 : 1
                        Behavior on scale { SpringAnimation { spring: 5; damping: 0.4 } }
                        Rectangle {
                            anchors.fill: parent
                            radius: sp.tab === index ? 14 : 20
                            Behavior on radius { NumberAnimation { duration: 280; easing.type: Easing.OutBack; easing.overshoot: 1.5 } }
                            color: sp.tab === index ? sp.pal.primaryContainer : (tma.containsMouse ? sp.pal.containerHigh : "transparent")
                            Behavior on color { ColorAnimation { duration: 200 } }
                        }
                        GlyphIcon { anchors.centerIn: parent; width: 20; height: 20; glyph: sp.tabGlyphs[index]
                            color: sp.tab === index ? sp.pal.fgOnPrimaryContainer : sp.pal.onSurfaceVariant
                            Behavior on color { ColorAnimation { duration: 200 } } }
                        MouseArea { id: tma; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: sp.tab = index }
                    }
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true; Layout.fillHeight: true; spacing: 2
            StyledText { text: sp.titles[sp.tab]; font.pixelSize: 20; font.bold: true; color: sp.pal.fg; Layout.leftMargin: 4 }
            StyledText { text: sp.subs[sp.tab]; font.pixelSize: 11; color: sp.pal.onSurfaceVariant; Layout.leftMargin: 4; Layout.bottomMargin: 6 }

            Item {
                Layout.fillWidth: true; Layout.fillHeight: true

                Flickable {
                    id: f0; anchors.fill: parent; clip: true; contentHeight: c0.height + 4; boundsBehavior: Flickable.StopAtBounds
                    opacity: sp.tab === 0 ? 1 : 0; visible: opacity > 0.01
                    x: sp.tab === 0 ? 0 : -24
                    Behavior on opacity { NumberAnimation { duration: 220 } }
                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Rectangle {
                        id: c0; width: f0.width; height: l0.implicitHeight + 28; radius: 24; color: sp.pal.container
                        ColumnLayout {
                            id: l0; anchors.fill: parent; anchors.margins: 14; spacing: 10
                            StyledText { text: "Grid Columns"; font.pixelSize: 14; font.bold: true; color: sp.pal.fg }
                            Segmented { pal: sp.pal; model: ["4", "5", "6"]; current: sp.cfg.cols; onPicked: i => sp.cfg.cols = i }
                            StyledText { text: "Icon Size"; font.pixelSize: 14; font.bold: true; color: sp.pal.fg }
                            Segmented { pal: sp.pal; model: ["Small", "Medium", "Large"]; current: sp.cfg.iconSize; onPicked: i => sp.cfg.iconSize = i }
                            StyledText { text: "Widget Size"; font.pixelSize: 14; font.bold: true; color: sp.pal.fg }
                            Segmented { pal: sp.pal; model: ["Compact", "Normal", "Wide"]; current: sp.cfg.sizeIdx; onPicked: i => sp.cfg.sizeIdx = i }
                            Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: sp.pal.containerHighest }
                            SettingRow { pal: sp.pal; title: "App Names"; desc: "Show names under icons."; checked: sp.cfg.showLabels; onToggled: v => sp.cfg.showLabels = v }
                            SettingRow { pal: sp.pal; title: "Favorites"; desc: "Pinned apps row."; checked: sp.cfg.showFavs; onToggled: v => sp.cfg.showFavs = v }
                            SettingRow { pal: sp.pal; title: "Categories"; desc: "Filter chips."; checked: sp.cfg.showCats; onToggled: v => sp.cfg.showCats = v }
                            SettingRow { pal: sp.pal; title: "Power Bar"; desc: "Lock, sleep, restart, logout, shut down."; checked: sp.cfg.showPower; onToggled: v => sp.cfg.showPower = v }
                            SettingRow { pal: sp.pal; title: "Confirm Power Actions"; desc: "Ask before restart, logout and shut down."; checked: sp.cfg.confirmPower; onToggled: v => sp.cfg.confirmPower = v; divider: false }
                        }
                    }
                }

                Flickable {
                    id: f1; anchors.fill: parent; clip: true; contentHeight: c1.height + 4; boundsBehavior: Flickable.StopAtBounds
                    opacity: sp.tab === 1 ? 1 : 0; visible: opacity > 0.01
                    x: sp.tab === 1 ? 0 : (sp.tab > 1 ? -24 : 24)
                    Behavior on opacity { NumberAnimation { duration: 220 } }
                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Rectangle {
                        id: c1; width: f1.width; height: l1.implicitHeight + 28; radius: 24; color: sp.pal.container
                        ColumnLayout {
                            id: l1; anchors.fill: parent; anchors.margins: 14; spacing: 10
                            StyledText { text: "Colours"; font.pixelSize: 14; font.bold: true; color: sp.pal.fg }
                            StyledText { text: "The launcher follows your Hydro colour scheme, so it changes with your wallpaper."; font.pixelSize: 11
                                color: sp.pal.onSurfaceVariant; wrapMode: Text.Wrap; Layout.fillWidth: true }
                            Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: sp.pal.containerHighest }
                            StyledText { text: "App Icon Shape"; font.pixelSize: 14; font.bold: true; color: sp.pal.fg }
                            Flow {
                                Layout.fillWidth: true; spacing: 8
                                Rectangle {
                                    width: 58; height: 44; radius: 22
                                    color: sp.cfg.iconShape === 0 ? sp.pal.primary : sp.pal.containerHighest
                                    Behavior on color { ColorAnimation { duration: 220 } }
                                    scale: pm.pressed ? 0.92 : 1; Behavior on scale { SpringAnimation { spring: 5; damping: 0.4 } }
                                    StyledText { anchors.centerIn: parent; text: "Plain"; font.pixelSize: 12; font.bold: true
                                        color: sp.cfg.iconShape === 0 ? sp.pal.fgOnPrimary : sp.pal.fg }
                                    MouseArea { id: pm; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sp.cfg.iconShape = 0 }
                                }
                                Repeater {
                                    model: sp.shapeList
                                    delegate: Item {
                                        width: 44; height: 44
                                        scale: shMa.pressed ? 0.88 : 1; Behavior on scale { SpringAnimation { spring: 5; damping: 0.4 } }
                                        MorphShape { anchors.fill: parent; shape: modelData
                                            color: sp.cfg.iconShape === index + 1 ? sp.pal.primary : sp.pal.containerHighest
                                            spin: sp.cfg.iconShape === index + 1 }
                                        MouseArea { id: shMa; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sp.cfg.iconShape = index + 1 }
                                    }
                                }
                            }
                            Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: sp.pal.containerHighest }
                            SettingRow { pal: sp.pal; title: "Hover Morph"; desc: "Icon shape morphs into a spinning cookie on hover."; checked: sp.cfg.hoverMorph; onToggled: v => sp.cfg.hoverMorph = v }
                            Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: sp.pal.containerHighest }
                            StyledText { text: "Launcher Icon"; font.pixelSize: 14; font.bold: true; color: sp.pal.fg }
                            StyledText { text: "The button shown in your panel."; font.pixelSize: 10; color: sp.pal.onSurfaceVariant }
                            Flow {
                                Layout.fillWidth: true; spacing: 8
                                Repeater {
                                    model: sp.panelGlyphs
                                    delegate: Item {
                                        width: 44; height: 44
                                        readonly property bool sel: sp.cfg.panelIcon === index
                                        scale: pgm.pressed ? 0.88 : 1; Behavior on scale { SpringAnimation { spring: 5; damping: 0.4 } }
                                        MorphShape { anchors.fill: parent; shape: parent.sel ? "cookie9" : "circle"; spin: parent.sel
                                            color: parent.sel ? sp.pal.primary : sp.pal.containerHighest }
                                        GlyphIcon { anchors.centerIn: parent; width: 22; height: 22; glyph: modelData
                                            color: parent.sel ? sp.pal.fgOnPrimary : sp.pal.fg
                                            Behavior on color { ColorAnimation { duration: 200 } } }
                                        MouseArea { id: pgm; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sp.cfg.panelIcon = index }
                                    }
                                }
                                Rectangle {
                                    width: 66; height: 44; radius: 22
                                    color: sp.cfg.panelIcon === sp.panelGlyphs.length ? sp.pal.primary : sp.pal.containerHighest
                                    Behavior on color { ColorAnimation { duration: 220 } }
                                    scale: stm.pressed ? 0.92 : 1; Behavior on scale { SpringAnimation { spring: 5; damping: 0.4 } }
                                    StyledText { anchors.centerIn: parent; text: "Hydro"; font.pixelSize: 12; font.bold: true
                                        color: sp.cfg.panelIcon === sp.panelGlyphs.length ? sp.pal.fgOnPrimary : sp.pal.fg }
                                    MouseArea { id: stm; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sp.cfg.panelIcon = sp.panelGlyphs.length }
                                }
                                Rectangle {
                                    width: 66; height: 44; radius: 22
                                    color: sp.cfg.panelIcon > sp.panelGlyphs.length ? sp.pal.primary : sp.pal.containerHighest
                                    Behavior on color { ColorAnimation { duration: 220 } }
                                    scale: cum.pressed ? 0.92 : 1; Behavior on scale { SpringAnimation { spring: 5; damping: 0.4 } }
                                    StyledText { anchors.centerIn: parent; text: "Custom"; font.pixelSize: 12; font.bold: true
                                        color: sp.cfg.panelIcon > sp.panelGlyphs.length ? sp.pal.fgOnPrimary : sp.pal.fg }
                                    MouseArea { id: cum; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: sp.cfg.panelIcon = sp.panelGlyphs.length + 1 }
                                }
                            }
                            Item {
                                Layout.fillWidth: true
                                Layout.preferredHeight: sp.cfg.panelIcon > sp.panelGlyphs.length ? 66 : 0
                                Behavior on Layout.preferredHeight { NumberAnimation { duration: 240; easing.type: Easing.OutCubic } }
                                clip: true; opacity: sp.cfg.panelIcon > sp.panelGlyphs.length ? 1 : 0
                                Behavior on opacity { NumberAnimation { duration: 200 } }
                                Column {
                                    width: parent.width; spacing: 4
                                    QC.TextField {
                                        id: customField
                                        width: parent.width; height: 42; leftPadding: 16; font.pixelSize: 13
                                        placeholderText: "Icon name or /path/to/image.png"
                                        color: sp.pal.fg; placeholderTextColor: sp.pal.onSurfaceVariant
                                        text: sp.cfg.customIcon
                                        background: Rectangle { radius: 21; color: sp.pal.containerHighest
                                            border.width: customField.activeFocus ? 2 : 0; border.color: sp.pal.primary }
                                        onTextEdited: sp.cfg.customIcon = text
                                    }
                                    StyledText { text: "Theme icon names (e.g. start-here) or a full path to a PNG/SVG."
                                        font.pixelSize: 10; color: sp.pal.onSurfaceVariant; wrapMode: Text.Wrap; width: parent.width }
                                }
                            }
                        }
                    }
                }

                Flickable {
                    id: f2; anchors.fill: parent; clip: true; contentHeight: c2.height + 4; boundsBehavior: Flickable.StopAtBounds
                    opacity: sp.tab === 2 ? 1 : 0; visible: opacity > 0.01
                    x: sp.tab === 2 ? 0 : 24
                    Behavior on opacity { NumberAnimation { duration: 220 } }
                    Behavior on x { NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                    Rectangle {
                        id: c2; width: f2.width; height: l2.implicitHeight + 28; radius: 24; color: sp.pal.container
                        ColumnLayout {
                            id: l2; anchors.fill: parent; anchors.margins: 14; spacing: 10
                            StyledText { text: "Applications"; font.pixelSize: 14; font.bold: true; color: sp.pal.fg }
                            StyledText { text: "Read from .desktop files (system, user and Flatpak). The list updates by itself."; font.pixelSize: 10; color: sp.pal.onSurfaceVariant; wrapMode: Text.Wrap; Layout.fillWidth: true }
                            Btn { pal: sp.pal; glyph: "restart"; text: "Rescan Applications"; onClicked: sp.rescan() }
                            Btn { pal: sp.pal; glyph: "close"; text: "Clear Recent Apps"; onClicked: sp.clearRecent() }
                            Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: sp.pal.containerHighest }
                            StyledText { text: "Super key"; font.pixelSize: 14; font.bold: true; color: sp.pal.fg }
                            StyledText { text: "Bind a key in your Hyprland config, for example Super alone. The button copies the line."
                                font.pixelSize: 11; color: sp.pal.onSurfaceVariant; wrapMode: Text.Wrap; Layout.fillWidth: true }
                            Btn { pal: sp.pal; glyph: "check"; text: "Copy the Hyprland bind"; onClicked: sp.assignShortcut() }
                            Rectangle { Layout.fillWidth: true; Layout.preferredHeight: 1; color: sp.pal.containerHighest }
                            Btn { pal: sp.pal; glyph: "restart"; text: "Reset to Defaults"; danger: true; onClicked: sp.resetAll() }
                        }
                    }
                }
            }
        }
    }
}
