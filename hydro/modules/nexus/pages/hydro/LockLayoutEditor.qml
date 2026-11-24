pragma ComponentBehavior: Bound

import QtQuick
import Quickshell
import qs.modules.common as HC
import qs.modules.lock
import qs.modules.nexus.compat
import qs.modules.nexus.components
import qs.modules.nexus.services

Item {
    id: root

    readonly property var lay: HC.Config.options.lock.layout
    readonly property var scr: Quickshell.screens.length > 0 ? Quickshell.screens[0] : null
    readonly property real sw: scr ? scr.width : 1920
    readonly property real sh: scr ? scr.height : 1080
    readonly property real k: width / sw          // preview pixels per screen pixel
    readonly property bool dashboard: lay.mode === "dashboard"
    readonly property real centerSnap: 14         // screen px within which a block snaps to the centre lines

    property string selected: "clock"
    property bool guideV: false
    property bool guideH: false

    implicitHeight: sh * k + toolbar.height + 24
    height: implicitHeight

    SystemClock { id: sysClock; precision: SystemClock.Minutes }

    function fx(n) { return n.indexOf("left") >= 0 ? 0 : (n.indexOf("right") >= 0 ? 1 : 0.5) }
    function fy(n) { return n.indexOf("top") >= 0 ? 0 : (n.indexOf("bottom") >= 0 ? 1 : 0.5) }
    function snapV(v) {
        const g = Math.max(1, lay.gridSize);
        return lay.snapToGrid ? Math.round(v / g) * g : Math.round(v);
    }
    function clamp(v, lo, hi) { return Math.max(lo, Math.min(hi, v)); }

    function centerSelected(horizontal, vertical) {
        for (let i = 0; i < rep.count; i++) {
            const it = rep.itemAt(i);
            if (!it || it.bid !== selected) continue;
            const o = it.cfg;
            const curX = posX(selected, o, it.rw), curY = posY(selected, o, it.rh);
            o.x = Math.round(horizontal ? (sw - it.rw) / 2 : curX);
            o.y = Math.round(vertical ? (sh - it.rh) / 2 : curY);
            o.anchor = "custom";
            return;
        }
    }

    function posX(id, obj, w) {
        const a = obj.anchor;
        if (a === "custom") return clamp(obj.x, 0, Math.max(0, sw - w));
        if (a !== "default") return clamp(lay.edgeMargin + fx(a) * Math.max(0, sw - 2 * lay.edgeMargin - w), 0, Math.max(0, sw - w));
        switch (id) {
        case "clock": return HC.Config.options.lock.centerClock ? (sw - w) / 2 : 72;
        case "card": case "power": return (sw - w) / 2;
        case "battery": return sw - w - 28;
        case "panelLeft": return 48;
        default: return sw - w - 48;
        }
    }
    function posY(id, obj, h) {
        const a = obj.anchor;
        if (a === "custom") return clamp(obj.y, 0, Math.max(0, sh - h));
        if (a !== "default") return clamp(lay.edgeMargin + fy(a) * Math.max(0, sh - 2 * lay.edgeMargin - h), 0, Math.max(0, sh - h));
        switch (id) {
        case "clock": return Math.max(56, sh * 0.14);
        case "card": return sh - Math.max(28, sh * 0.05) - 52 - 28 - h;
        case "power": return sh - Math.max(28, sh * 0.05) - h;
        case "battery": return 28;
        default: return (sh - h) / 2;
        }
    }

    readonly property var blockIds: dashboard ? ["clock", "card", "power", "battery", "panelLeft", "panelRight"]
                                              : ["clock", "card", "power", "battery"]
    function cfgOf(id) { return lay[id]; }
    function enabledOf(id) {
        switch (id) {
        case "clock": return lay.clock.enable;
        case "power": return lay.power.enable;
        case "battery": return lay.battery.enable;
        default: return true;
        }
    }
    function compOf(id) {
        switch (id) {
        case "clock": return clockC;
        case "card": return cardC;
        case "power": return powerC;
        case "battery": return batteryC;
        case "panelLeft": return panelLC;
        default: return panelRC;
        }
    }

    Component { id: clockC; LockClockBlock { date: sysClock.date; lay: root.lay; textAlign: Qt.AlignHCenter; screenHeight: root.sh } }
    Component { id: powerC; LockPowerRow { interactive: false } }
    Component { id: batteryC; LockBatteryPill {} }
    Component { id: panelLC; PanelLeft { width: Math.min(360, root.sw * 0.24) } }
    Component { id: panelRC; PanelRight { width: Math.min(360, root.sw * 0.24) } }
    Component {
        id: cardC
        Rectangle { // static stand-in for the profile card (the real one is interactive)
            implicitWidth: Math.min(root.lay.card.width, root.sw - 48)
            implicitHeight: 130
            radius: 36
            readonly property color base: HC.Appearance.m3colors.m3surfaceContainerHigh
            color: Qt.rgba(base.r, base.g, base.b, 0.88)
            border.width: 1
            border.color: Qt.rgba(1, 1, 1, 0.14)
            Rectangle {
                x: 26; anchors.verticalCenter: parent.verticalCenter
                width: 76; height: 76; radius: 38
                color: HC.Appearance.colors.colPrimary
            }
            Column {
                x: 128; anchors.verticalCenter: parent.verticalCenter
                spacing: 10
                Rectangle { width: 130; height: 18; radius: 9; color: HC.Appearance.colors.colOnLayer1; opacity: 0.8 }
                Rectangle {
                    width: parent.parent.width - 128 - 26; height: 50; radius: 25
                    color: Qt.rgba(1, 1, 1, 0.07)
                    border.width: 1; border.color: Qt.rgba(1, 1, 1, 0.22)
                }
            }
        }
    }

    Rectangle {
        id: screenBox
        width: root.width
        height: root.sh * root.k
        radius: 14
        color: Colours.palette.m3surfaceContainer
        clip: true
        border.width: 1
        border.color: Colours.palette.m3outlineVariant

        Image {
            anchors.fill: parent
            source: HC.Config.options.background.wallpaperPath.length > 0 ? "file://" + HC.Config.options.background.wallpaperPath : ""
            fillMode: Image.PreserveAspectCrop
            asynchronous: true
        }
        Rectangle { anchors.fill: parent; color: "black"; opacity: 0.35 }

        Canvas {
            anchors.fill: parent
            visible: root.lay.snapToGrid
            opacity: 0.25
            property real step: root.lay.gridSize * root.k
            onStepChanged: requestPaint()
            onWidthChanged: requestPaint()
            onPaint: {
                const ctx = getContext("2d");
                ctx.reset();
                if (step < 6) return;
                ctx.fillStyle = "white";
                for (let x = 0; x < width; x += step)
                    for (let y = 0; y < height; y += step)
                        ctx.fillRect(x, y, 1, 1);
            }
        }

        Rectangle { x: screenBox.width / 2; width: 1; height: parent.height; color: Colours.palette.m3primary; opacity: root.guideV ? 1 : 0.18; Behavior on opacity { NumberAnimation { duration: 100 } } }
        Rectangle { y: screenBox.height / 2; height: 1; width: parent.width; color: Colours.palette.m3primary; opacity: root.guideH ? 1 : 0.18; Behavior on opacity { NumberAnimation { duration: 100 } } }

        Repeater {
            id: rep
            model: root.blockIds
            delegate: Item {
                id: blk
                required property string modelData
                readonly property string bid: modelData
                readonly property var cfg: root.cfgOf(bid)
                visible: root.enabledOf(bid)
                readonly property real rw: ld.item ? Math.max(1, ld.item.width, ld.item.implicitWidth) : 60
                readonly property real rh: ld.item ? Math.max(1, ld.item.height, ld.item.implicitHeight) : 40
                width: rw * root.k
                height: rh * root.k
                z: area.dragging ? 10 : (root.selected === blk.bid ? 5 : 1)

                Binding { target: blk; property: "x"; when: !area.dragging; value: root.posX(blk.bid, blk.cfg, blk.rw) * root.k }
                Binding { target: blk; property: "y"; when: !area.dragging; value: root.posY(blk.bid, blk.cfg, blk.rh) * root.k }

                Loader {
                    id: ld
                    sourceComponent: root.compOf(blk.bid)
                    scale: root.k
                    transformOrigin: Item.TopLeft
                    enabled: false          // purely visual
                }

                Rectangle { // selection / custom outline
                    anchors.fill: parent
                    anchors.margins: -2
                    radius: 8
                    color: area.dragging ? Qt.alpha(Colours.palette.m3primary, 0.15) : "transparent"
                    border.width: root.selected === blk.bid || area.dragging ? 2 : (blk.cfg.anchor === "custom" ? 1 : 0)
                    border.color: Colours.palette.m3primary
                }

                function place(rawX, rawY) {
                    let sx = rawX, sy = rawY, gv = false, gh = false;
                    if (Math.abs(sx + rw / 2 - root.sw / 2) < root.centerSnap) { sx = (root.sw - rw) / 2; gv = true; }
                    else sx = root.snapV(sx);
                    if (Math.abs(sy + rh / 2 - root.sh / 2) < root.centerSnap) { sy = (root.sh - rh) / 2; gh = true; }
                    else sy = root.snapV(sy);
                    sx = root.clamp(sx, 0, Math.max(0, root.sw - rw));
                    sy = root.clamp(sy, 0, Math.max(0, root.sh - rh));
                    root.guideV = gv;
                    root.guideH = gh;
                    blk.x = sx * root.k;     // the block itself jumps from grid point to grid point
                    blk.y = sy * root.k;
                    blk.pendX = Math.round(sx);
                    blk.pendY = Math.round(sy);
                }

                property real pendX: 0
                property real pendY: 0
                property bool moved: false
                function save() {   // one config write, when the mouse is released
                    if (!moved) return;
                    moved = false;
                    cfg.x = pendX;
                    cfg.y = pendY;
                    cfg.anchor = "custom";
                }

                MouseArea {
                    id: area
                    anchors.fill: parent
                    property bool dragging: false
                    preventStealing: true      // the settings page scrolls: do not let it take over the drag
                    property point grab: Qt.point(0, 0)
                    cursorShape: dragging ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                    onPressed: mouse => {
                        root.selected = blk.bid;
                        grab = Qt.point(mouse.x, mouse.y);
                        dragging = true;
                    }
                    onPositionChanged: mouse => {
                        if (!dragging) return;
                        const p = mapToItem(screenBox, mouse.x, mouse.y);
                        blk.moved = true;
                        blk.place((p.x - grab.x) / root.k, (p.y - grab.y) / root.k);
                    }
                    onReleased: { blk.save(); dragging = false; root.guideV = false; root.guideH = false; }
                    onCanceled: { blk.save(); dragging = false; root.guideV = false; root.guideH = false; }
                }
            }
        }
    }

    Flow {
        id: toolbar
        anchors { top: screenBox.bottom; topMargin: 12; left: parent.left; right: parent.right }
        spacing: 10

        component Btn: Rectangle {
            id: b
            property alias label: lbl.text
            signal clicked
            width: lbl.implicitWidth + 28
            height: 36
            radius: 18
            color: Colours.palette.m3secondaryContainer
            StyledText { id: lbl; anchors.centerIn: parent; color: Colours.palette.m3onSecondaryContainer }
            MouseArea { anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: b.clicked() }
        }

        Btn { label: Tr.tr("Center horizontally"); onClicked: root.centerSelected(true, false) }
        Btn { label: Tr.tr("Center vertically"); onClicked: root.centerSelected(false, true) }
        Btn { label: Tr.tr("Center both"); onClicked: root.centerSelected(true, true) }
        Btn { label: Tr.tr("Reset all"); onClicked: { const L = root.lay; [L.clock, L.card, L.power, L.battery, L.panelLeft, L.panelRight].forEach(o => o.anchor = "default"); } }
    }
}
