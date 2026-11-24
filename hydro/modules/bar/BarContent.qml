import QtQuick
import Quickshell
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root

    property var screen: root.QsWindow.window?.screen
    property var brightnessMonitor: Brightness.getMonitorForScreen(screen)
    readonly property real sideMargin: 14
    readonly property bool floating: Config.options.bar.cornerStyle === 1
    readonly property var sections: ({ left: leftSection, center: centerSection, right: rightSection })

    function dropWidget(widgetId, fromName, centerX) {
        const layout = Config.options.bar.hydroLayout;
        const lists = {
            left: Array.from(layout.left),
            center: Array.from(layout.center),
            right: Array.from(layout.right)
        };
        const from = lists[fromName].indexOf(widgetId);
        if (from < 0) return;

        const target = centerX < root.width / 3 ? "left" : (centerX > root.width * 2 / 3 ? "right" : "center");
        const index = root.sections[target].slotIndexAt(centerX, widgetId);

        lists[fromName].splice(from, 1);
        lists[target].splice(Math.min(index, lists[target].length), 0, widgetId);

        for (const name of ["left", "center", "right"]) {
            if (JSON.stringify(lists[name]) !== JSON.stringify(Array.from(layout[name])))
                layout[name] = lists[name];
        }
        editTimeout.restart();
    }

    Timer {
        id: editTimeout
        interval: 20000
        onTriggered: GlobalStates.barEditMode = false
    }
    Connections {
        target: GlobalStates
        function onBarEditModeChanged() {
            if (GlobalStates.barEditMode) editTimeout.restart();
            else editTimeout.stop();
        }
    }

    function roleColor(name) {
        if (!name) return "transparent";
        if (name.charAt(0) === "#") return name;
        const p = name.split("_");
        const key = "m3" + p[0] + p.slice(1).map(s => s.charAt(0).toUpperCase() + s.slice(1)).join("");
        return Appearance.m3colors[key] ?? "transparent";
    }
    readonly property var shape: Config.options.bar.shape
    function corner(v) { return v >= 0 ? v : root.shape.cornerRadius; }

    BarShape {
        anchors {
            fill: parent
            margins: root.floating ? Appearance.sizes.hyprlandGapsOut : 0
        }
        fillColor: (Config.options.bar.showBackground && !Config.options.bar.islands.enable) ? "#000000" : "transparent"
        borderColor: root.roleColor(root.shape.borderColor)
        borderWidth: root.shape.borderWidth

        readonly property bool carve: !root.floating && root.shape.concaveEdgeCorners
        readonly property bool innerIsTop: Config.options.bar.bottom // bottom bar: the inner edge is its top
        topLeft: root.floating ? root.corner(root.shape.topLeft) : (carve && innerIsTop ? root.corner(root.shape.topLeft) : 0)
        topRight: root.floating ? root.corner(root.shape.topRight) : (carve && innerIsTop ? root.corner(root.shape.topRight) : 0)
        bottomLeft: root.floating ? root.corner(root.shape.bottomLeft) : (carve && !innerIsTop ? root.corner(root.shape.bottomLeft) : 0)
        bottomRight: root.floating ? root.corner(root.shape.bottomRight) : (carve && !innerIsTop ? root.corner(root.shape.bottomRight) : 0)
        concaveTop: carve && innerIsTop
        concaveBottom: carve && !innerIsTop
    }

    FocusedScrollMouseArea { // left half: brightness | hold to toggle edit mode
        anchors { top: parent.top; bottom: parent.bottom; left: parent.left; right: centerSection.left }
        onScrollDown: Brightness.decreaseBrightness()
        onScrollUp: Brightness.increaseBrightness()
        onMovedAway: GlobalStates.osdBrightnessOpen = false
        onPressAndHold: GlobalStates.barEditMode = !GlobalStates.barEditMode
    }

    FocusedScrollMouseArea { // right half: volume | hold to toggle edit mode
        anchors { top: parent.top; bottom: parent.bottom; left: centerSection.right; right: parent.right }
        onScrollDown: Audio.decrementVolume()
        onScrollUp: Audio.incrementVolume()
        onMovedAway: GlobalStates.osdVolumeOpen = false
        onPressAndHold: GlobalStates.barEditMode = !GlobalStates.barEditMode
    }

    HydroBarSection {
        id: leftSection
        sectionName: "left"
        ids: Config.options.bar.hydroLayout.left
        dragSpace: root
        onDropped: (widgetId, fromSection, centerX) => root.dropWidget(widgetId, fromSection, centerX)
        anchors {
            left: parent.left
            leftMargin: root.sideMargin
            verticalCenter: parent.verticalCenter
        }
    }

    HydroBarSection {
        id: centerSection
        sectionName: "center"
        ids: Config.options.bar.hydroLayout.center
        dragSpace: root
        onDropped: (widgetId, fromSection, centerX) => root.dropWidget(widgetId, fromSection, centerX)
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
    }

    HydroBarSection {
        id: rightSection
        sectionName: "right"
        ids: Config.options.bar.hydroLayout.right
        dragSpace: root
        onDropped: (widgetId, fromSection, centerX) => root.dropWidget(widgetId, fromSection, centerX)
        anchors {
            right: parent.right
            rightMargin: root.sideMargin
            verticalCenter: parent.verticalCenter
        }
    }
}
