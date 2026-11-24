import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.widgets.settings
import qs.modules.settings.hydro

ColumnLayout {
    id: root

    readonly property var layoutCfg: Config.options.bar.hydroLayout
    readonly property var laneNames: ["left", "center", "right"]
    readonly property var laneTitles: ({
        left: Translation.tr("Start"),
        center: Translation.tr("Center"),
        right: Translation.tr("End")
    })
    readonly property var catalog: ({
        logo:          { name: "Launcher",        icon: "hexagon" },
        windowTitle:   { name: "Window Title",    icon: "web_asset" },
        workspaces:    { name: "Workspaces",      icon: "workspaces" },
        tray:          { name: "Tray",            icon: "widgets" },
        status:        { name: "Status",          icon: "tune" },
        clock:         { name: "Clock",           icon: "schedule" },
        launcher:      { name: "App Search",      icon: "apps" },
        leftSidebar:   { name: "Left Sidebar",    icon: "left_panel_open" },
        activeWindow:  { name: "Active Window",   icon: "select_window" },
        media:         { name: "Media",           icon: "music_note" },
        mediaPlayer:   { name: "Media Player",    icon: "play_circle" },
        mediaFace:     { name: "Media Face",      icon: "album" },
        resources:     { name: "Resources",       icon: "monitoring" },
        cpu:           { name: "CPU",             icon: "memory" },
        ram:           { name: "RAM",             icon: "memory_alt" },
        network:       { name: "Network",         icon: "wifi" },
        battery:       { name: "Battery",         icon: "battery_full" },
        notifications: { name: "Notifications",   icon: "notifications" },
        weather:       { name: "Weather",         icon: "partly_cloudy_day" },
        utilButtons:   { name: "Utility Buttons", icon: "construction" }
    })

    readonly property var hiddenIds: Array.from(layoutCfg.hidden)
    readonly property var available: {
        const used = [].concat(Array.from(layoutCfg.left), Array.from(layoutCfg.center), Array.from(layoutCfg.right));
        return Object.keys(catalog).filter(id => used.indexOf(id) < 0);
    }
    property alias lanesRowItem: lanesRow
    property var laneItems: ({ left: laneLeft, center: laneCenter, right: laneRight })

    function nameOf(id) { return catalog[id]?.name ?? id; }
    function iconOf(id) { return catalog[id]?.icon ?? "widgets"; }
    function listOf(lane) { return Array.from(layoutCfg[lane]); }
    function setList(lane, list) { Config.options.bar.hydroLayout[lane] = list; }
    function setHidden(list) { Config.options.bar.hydroLayout.hidden = list; }

    function addWidget(lane, id) {
        const l = listOf(lane); l.push(id); setList(lane, l);
    }
    function removeWidget(lane, id) {
        setList(lane, listOf(lane).filter(w => w !== id));
        setHidden(hiddenIds.filter(w => w !== id));
    }
    function toggleHidden(id) {
        setHidden(hiddenIds.indexOf(id) >= 0 ? hiddenIds.filter(w => w !== id) : hiddenIds.concat([id]));
    }
    function drop(id, fromLane, p) {
        let target = fromLane;
        for (const name of laneNames) {
            const it = laneItems[name];
            if (p.x >= it.x && p.x <= it.x + it.width) { target = name; break; }
        }
        const lane = laneItems[target];
        let index = 0;
        for (let i = 0; i < lane.repeater.count; i++) {
            const row = lane.repeater.itemAt(i);
            if (!row || row.modelData === id) continue;
            const cy = row.mapToItem(lanesRow, 0, row.height / 2).y;
            if (cy < p.y) index++;
        }
        const from = listOf(fromLane).filter(w => w !== id);
        if (target === fromLane) {
            from.splice(Math.min(index, from.length), 0, id);
            if (JSON.stringify(from) !== JSON.stringify(listOf(fromLane))) setList(fromLane, from);
        } else {
            const to = listOf(target);
            to.splice(Math.min(index, to.length), 0, id);
            setList(fromLane, from);
            setList(target, to);
        }
    }

    Layout.fillWidth: true
    Layout.leftMargin: SettingsTheme.spacingM
    Layout.rightMargin: SettingsTheme.spacingM
    spacing: SettingsTheme.spacingS

    StyledText {
        text: Translation.tr("Arrange widgets across the bar lanes. Drag the handle to reorder or move between lanes.")
        font.pixelSize: SettingsTheme.fontSizeSmall
        color: SettingsTheme.surfaceVariantText
        Layout.fillWidth: true
        wrapMode: Text.WordWrap
    }

    RowLayout {
        id: lanesRow
        Layout.fillWidth: true
        spacing: SettingsTheme.spacingM

        WidgetLane { id: laneLeft; manager: root; laneName: "left" }
        WidgetLane { id: laneCenter; manager: root; laneName: "center" }
        WidgetLane { id: laneRight; manager: root; laneName: "right" }
    }
}
