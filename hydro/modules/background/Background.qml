import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions
import QtQuick
import qs.modules.desktopWidgets.cards
import qs.modules.desktopWidgets.ui
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

Variants {
    model: Quickshell.screens

    PanelWindow {
        id: bgRoot
        required property var modelData
        screen: modelData

        readonly property HyprlandMonitor monitor: Hyprland.monitorFor(modelData)
        readonly property var cfg: Config.options.background
        readonly property string wallpaperPath: cfg.wallpaperPath
        readonly property bool isVideo: /\.(mp4|webm|mkv|avi|mov)$/i.test(wallpaperPath)
        readonly property string defaultWallpaper: Quickshell.shellPath("assets/images/default_wallpaper.png")
        readonly property string imagePath: wallpaperPath.length === 0 ? defaultWallpaper : (isVideo ? cfg.thumbnailPath : wallpaperPath)

        readonly property bool wallpaperSafetyTriggered: {
            if (!Config.options.workSafety.enable.wallpaper) return false;
            const sensitiveWallpaper = StringUtils.stringListContainsSubstring(wallpaperPath.toLowerCase(), Config.options.workSafety.triggerCondition.fileKeywords);
            const sensitiveNetwork = StringUtils.stringListContainsSubstring(Network.networkName.toLowerCase(), Config.options.workSafety.triggerCondition.networkNameKeywords);
            return sensitiveWallpaper && sensitiveNetwork;
        }
        readonly property bool hasWallpaper: imagePath.length > 0 && !isVideo && !wallpaperSafetyTriggered

        readonly property bool fullscreenHere: cfg.hideWhenFullscreen && (HyprlandData.workspaceById[monitor?.activeWorkspace?.id]?.hasfullscreen ?? false)
        visible: !fullscreenHere

        readonly property int wsShown: Config.options.bar.workspaces.shown
        readonly property int wsIndex: Math.max(0, ((monitor?.activeWorkspace?.id ?? 1) - 1) % wsShown)
        readonly property bool parallaxActive: cfg.parallax.enableWorkspace || cfg.parallax.enableSidebar
        readonly property real zoom: parallaxActive ? Math.max(1, cfg.parallax.workspaceZoom) : 1
        readonly property real maxShiftX: width * (zoom - 1)
        readonly property real maxShiftY: height * (zoom - 1)
        readonly property bool vertical: cfg.parallax.vertical || (cfg.parallax.autoVertical && height > width)
        property real parallaxT: {
            let t = 0.5;
            if (cfg.parallax.enableWorkspace && wsShown > 1)
                t = wsIndex / (wsShown - 1);
            if (cfg.parallax.enableSidebar) {
                if (GlobalStates.sidebarRightOpen) t = Math.min(1, t + 0.12 * cfg.parallax.widgetsFactor);
                if (GlobalStates.sidebarLeftOpen) t = Math.max(0, t - 0.12 * cfg.parallax.widgetsFactor);
            }
            return t;
        }

        WlrLayershell.namespace: "quickshell:background"
        WlrLayershell.layer: WlrLayer.Background
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: HwConfig.editMode ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
        color: "transparent"
        anchors { top: true; bottom: true; left: true; right: true }

        Rectangle {
            id: canvas
            anchors.fill: parent
            color: bgRoot.hasWallpaper ? Appearance.m3colors.m3background : "transparent"
            clip: true

            Image {
                id: wallpaper
                visible: bgRoot.hasWallpaper && !GlobalStates.screenLocked
                width: canvas.width * bgRoot.zoom
                height: canvas.height * bgRoot.zoom
                x: -bgRoot.maxShiftX * (bgRoot.vertical ? 0.5 : bgRoot.parallaxT)
                y: -bgRoot.maxShiftY * (bgRoot.vertical ? bgRoot.parallaxT : 0.5)
                source: bgRoot.hasWallpaper ? Qt.resolvedUrl(bgRoot.imagePath) : ""
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                cache: false
                smooth: true
                retainWhileLoading: true
                sourceSize: Qt.size(width * bgRoot.devicePixelRatio, height * bgRoot.devicePixelRatio)

                Behavior on x { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
                Behavior on y { NumberAnimation { duration: 500; easing.type: Easing.OutCubic } }
                onStatusChanged: if (status === Image.Ready) fadeIn.restart()
                NumberAnimation { id: fadeIn; target: wallpaper; property: "opacity"; from: 0.0; to: 1.0; duration: 350; easing.type: Easing.OutCubic }
            }

            GaussianBlur {
                anchors.fill: wallpaper
                source: wallpaper
                radius: 48
                samples: 97
                visible: bgRoot.hasWallpaper && GlobalStates.screenLocked
                opacity: GlobalStates.screenLocked ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 300 } }
            }

            DesktopWidgetLayer {
                anchors.fill: parent
                visible: HwConfig.anyLive
            }

            MouseArea {
                anchors.fill: parent
                z: -1        // below the widgets, so they keep their own clicks
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onPressed: mouse => {
                    if (HwConfig.editMode) HwConfig.selected = "";               // click the empty desktop: deselect
                    else if (mouse.button === Qt.RightButton) deskMenu.show(mouse.x, mouse.y);
                }
            }
            DesktopEditOverlay {
                anchors.fill: parent
                z: 90
            }
            DesktopContextMenu {
                id: deskMenu
                anchors.fill: parent
                z: 100
            }

            BackgroundClock {
                visible: cfg.widgets.clock.enable && (!cfg.widgets.clock.showOnlyWhenLocked || GlobalStates.screenLocked)
                canvasWidth: canvas.width
                canvasHeight: canvas.height
                wallpaperPath: bgRoot.wallpaperSafetyTriggered ? "" : bgRoot.imagePath
            }
        }
    }
}
