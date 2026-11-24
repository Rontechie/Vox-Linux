import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import qs.modules.background.clock
import qs.modules.desktopWidgets.ui
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root
    property real canvasWidth
    property real canvasHeight
    property string wallpaperPath: ""   // image used for leastBusy / mostBusy placement

    readonly property var cfg: Config.options.background.widgets.clock
    readonly property var ck: cfg.cookie
    readonly property string styleName: GlobalStates.screenLocked ? cfg.styleLocked : cfg.style
    readonly property bool cookie: styleName !== "digital"
    readonly property string strategy: cfg.placementStrategy
    readonly property bool autoPlace: strategy === "leastBusy" || strategy === "mostBusy"

    opacity: cfg.widgetOpacity
    implicitWidth: content.implicitWidth
    implicitHeight: content.implicitHeight
    width: implicitWidth
    height: implicitHeight

    property bool placed: false
    property real autoCenterX: canvasWidth / 2
    property real autoCenterY: canvasHeight * 0.28 + height / 2
    readonly property string preset: HwConfig.general.clockAnchor ?? "custom"
    readonly property real edge: HwConfig.general.edgeMargin
    readonly property real insetTop: HwLayer.barEdge === "top" ? HwLayer.topBaseH : 0
    readonly property real insetBottom: HwLayer.barEdge === "bottom" ? HwLayer.topBaseH : 0
    readonly property real presetX: edge + (preset.indexOf("left") >= 0 ? 0 : (preset.indexOf("right") >= 0 ? 1 : 0.5)) * Math.max(0, canvasWidth - 2 * edge - width)
    readonly property real presetY: insetTop + edge + (preset.indexOf("top") >= 0 ? 0 : (preset.indexOf("bottom") >= 0 ? 1 : 0.5)) * Math.max(0, canvasHeight - insetTop - insetBottom - 2 * edge - height)
    function snap(v) { return Math.round(v / HwLayer.snapCell) * HwLayer.snapCell }
    readonly property real wantX: strategy === "free" ? (preset !== "custom" ? presetX : snap(cfg.x)) : (placed ? autoCenterX : canvasWidth / 2) - width / 2
    readonly property real wantY: strategy === "free" ? (preset !== "custom" ? presetY : snap(cfg.y)) : (placed ? autoCenterY - height / 2 : canvasHeight * 0.28)
    x: Math.max(0, Math.min(wantX, Math.max(0, canvasWidth - width)))
    y: Math.max(0, Math.min(wantY, Math.max(0, canvasHeight - height)))
    Behavior on x { enabled: root.placed; NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
    Behavior on y { enabled: root.placed; NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }

    property color dominantColor: "#000000"
    property bool haveDominant: false
    readonly property color colText: haveDominant
        ? ColorUtils.colorWithLightness(Appearance.colors.colPrimary, ColorUtils.isDark(dominantColor) ? 0.85 : 0.15)
        : Appearance.colors.colOnLayer0

    property bool repositionPending: false
    function reposition() {
        if (!autoPlace || wallpaperPath.length === 0 || canvasWidth <= 0 || canvasHeight <= 0 || width <= 0) return;
        if (placeProc.running) { repositionPending = true; return; }
        const pad = Math.round(Math.max(width, height) / 2) + 30;
        const cmd = [
            Quickshell.shellPath("scripts/images/least-busy-region-venv.sh"),
            "--screen-width", String(Math.round(canvasWidth)),
            "--screen-height", String(Math.round(canvasHeight)),
            "--width", String(Math.round(width)),
            "--height", String(Math.round(height)),
            "--horizontal-padding", String(pad),
            "--vertical-padding", String(pad),
            "--stride", "10"
        ];
        if (strategy === "mostBusy") cmd.push("--busiest");
        cmd.push(wallpaperPath);
        placeProc.exec({ command: cmd });
    }
    Timer {
        id: repositionTimer
        interval: 400
        onTriggered: root.reposition()
    }
    onWallpaperPathChanged: repositionTimer.restart()
    onStrategyChanged: repositionTimer.restart()
    onCanvasWidthChanged: repositionTimer.restart()
    onCanvasHeightChanged: repositionTimer.restart()
    onHeightChanged: repositionTimer.restart()
    Component.onCompleted: repositionTimer.restart()

    Process {
        id: placeProc
        stdout: StdioCollector {
            onStreamFinished: {
                const out = text.trim();
                if (out.length === 0) return; // script unavailable -> keep the centred fallback
                try {
                    const r = JSON.parse(out);
                    if (r.error) return;
                    root.autoCenterX = r.center_x;
                    root.autoCenterY = r.center_y;
                    root.dominantColor = r.dominant_color || "#000000";
                    root.haveDominant = !!r.dominant_color;
                    root.placed = true;
                } catch (e) {
                    console.warn("[BackgroundClock] could not parse placement output:", e);
                }
            }
        }
        onExited: {
            if (root.repositionPending) {
                root.repositionPending = false;
                root.reposition();
            }
        }
    }

    ColumnLayout {
        id: content
        spacing: 10

        Loader {
            Layout.alignment: Qt.AlignHCenter
            sourceComponent: root.styleName === "material" ? materialComp : (root.cookie ? cookieComp : digitalComp)
        }
        Component { id: cookieComp; CookieClock { } }
        Component { id: materialComp; MaterialAnalogClock { } }
        Component {
            id: digitalComp
            DigitalClock {
                colText: root.colText
                canvasWidth: root.canvasWidth
                clockCenterX: root.x + root.width / 2
            }
        }

        StyledText {
            visible: root.cookie && !root.ck.dateInClock && root.ck.dateStyle !== "hide"
            Layout.alignment: Qt.AlignHCenter
            text: DateTime.longDate
            color: root.colText
            font.pixelSize: Appearance.font.pixelSize.larger
            style: Text.Raised
            styleColor: Appearance.colors.colShadow
        }

        StyledText {
            visible: root.cfg.quote.enable && root.cfg.quote.text.length > 0
            Layout.alignment: Qt.AlignHCenter
            Layout.maximumWidth: 360
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.Wrap
            text: root.cfg.quote.text
            color: root.colText
            font.pixelSize: Appearance.font.pixelSize.large
            style: Text.Raised
            styleColor: Appearance.colors.colShadow
        }

        Rectangle {
            visible: GlobalStates.screenLocked
            Layout.alignment: Qt.AlignHCenter
            implicitWidth: lockRow.implicitWidth + 28
            implicitHeight: lockRow.implicitHeight + 14
            radius: height / 2
            color: Appearance.colors.colLayer2
            RowLayout {
                id: lockRow
                anchors.centerIn: parent
                spacing: 6
                MaterialSymbol {
                    text: "lock"
                    iconSize: 18
                    color: Appearance.colors.colOnLayer2
                }
                StyledText {
                    text: Translation.tr("Session Locked")
                    color: Appearance.colors.colOnLayer2
                }
            }
        }
    }
}
