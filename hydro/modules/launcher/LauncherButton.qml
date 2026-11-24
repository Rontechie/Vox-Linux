import qs
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import Quickshell
import Quickshell.Widgets

Item {
    id: cr

    property real ws: 1
    readonly property var cfg: Config.options.launcher
    readonly property bool open: GlobalStates.launcherOpen
    readonly property var panelGlyphs: ["apps", "menu", "home", "star", "favorite", "widgets", "dashboard", "bolt", "eco"]
    readonly property int logoIdx: panelGlyphs.length     // the Hydro logo
    readonly property string customSrc: {
        const c = cfg.customIcon.trim();
        if (c === "") return Quickshell.iconPath("application-x-executable");
        if (c.charAt(0) === "/") return "file://" + c;
        return Quickshell.iconPath(c, "application-x-executable");
    }

    readonly property bool capsuleOn: Config.options.bar.capsules.enable && !Config.options.bar.islands.enable
    readonly property color restFill: !capsuleOn ? "transparent" : (Appearance.capsuleCustom ? Appearance.capsuleFill : Appearance.m3colors.m3surfaceContainerHigh)

    implicitWidth: 38 * ws
    implicitHeight: 38 * ws

    MorphShape {
        anchors.centerIn: parent
        width: 36 * cr.ws
        height: width
        shape: cr.open ? "cookie9" : (cma.pressed ? "square" : (cma.containsMouse ? "cookie6" : "circle"))
        spin: cr.open || cma.containsMouse
        spinPeriod: 8000
        color: cr.open ? Appearance.colors.colPrimary : (cma.containsMouse ? Appearance.colors.colPrimaryContainer : cr.restFill)
    }
    GlyphIcon {
        visible: cr.cfg.panelIcon < cr.logoIdx
        anchors.centerIn: parent
        width: parent.width * 0.52
        height: width
        glyph: cr.panelGlyphs[Math.max(0, Math.min(cr.panelGlyphs.length - 1, cr.cfg.panelIcon))]
        color: cr.open ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer0
        Behavior on color { ColorAnimation { duration: 180 } }
    }
    CustomIcon {
        visible: cr.cfg.panelIcon === cr.logoIdx
        anchors.centerIn: parent
        width: 20 * cr.ws
        height: 20 * cr.ws
        source: "hydro-symbolic.svg"
        colorize: true
        color: cr.open ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer0
    }
    IconImage {
        visible: cr.cfg.panelIcon > cr.logoIdx
        anchors.centerIn: parent
        implicitSize: 22 * cr.ws
        source: cr.customSrc
    }
    MouseArea {
        id: cma
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: GlobalStates.launcherOpen = !GlobalStates.launcherOpen
    }
}
