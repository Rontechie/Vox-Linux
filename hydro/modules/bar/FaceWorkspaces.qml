import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import qs
import qs.services
import qs.modules.common

HydroPill {
    id: root
    property string face: "pills"
    clickable: false
    hPadding: 10

    readonly property string orientation: "horizontal"
    readonly property bool isCompact: false
    readonly property var barWindow: null
    readonly property bool moduleActive: true
    readonly property bool hideEmptyWorkspaces: false
    readonly property var niriOccupiedMap: ({})
    readonly property var swayOccupiedMap: ({})
    readonly property var mangoOccupiedMap: ({})
    readonly property var umbrielOccupiedMap: ({})
    function s(v) { return Math.round(v * Config.options.bar.sizes.widgetScale); }

    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.QsWindow.window?.screen)
    readonly property int activeId: monitor?.activeWorkspace?.id ?? 1
    readonly property int activeIndex: activeId - 1
    readonly property int workspaceCount: Math.max(2, Config.options.bar.workspaces.shown, activeId)

    function isOccupied(index) {
        return HyprlandData.windowList.some(w => w.workspace?.id === index + 1);
    }
    function isShown(index) { return true; }
    function focusWorkspace(index) {
        Hyprland.dispatch(`hl.dsp.focus({workspace = ${index + 1}})`);
    }

    ListModel { id: wsModel }
    function syncModel() {
        while (wsModel.count < workspaceCount) wsModel.append({ "modelData": wsModel.count });
        while (wsModel.count > workspaceCount) wsModel.remove(wsModel.count - 1);
    }
    onWorkspaceCountChanged: syncModel()
    function findRepeater(obj) { // the faces own a Repeater; hand it our model
        if (!obj) return null;
        if (obj.model !== undefined && obj.count !== undefined && typeof obj.itemAt === "function") return obj;
        const kids = obj.children ?? [];
        for (let i = 0; i < kids.length; i++) { const r = findRepeater(kids[i]); if (r) return r; }
        const data = obj.data ?? [];
        for (let j = 0; j < data.length; j++) { const r = findRepeater(data[j]); if (r) return r; }
        return null;
    }
    function attach() {
        if (!loader.item) return;
        loader.item.widget = root;
        const rep = findRepeater(loader.item);
        if (rep && rep.model !== wsModel) rep.model = wsModel;
    }
    Component.onCompleted: syncModel()

    Loader {
        id: loader
        Layout.alignment: Qt.AlignVCenter
        source: Qt.resolvedUrl("faces/" + ({ pills: "PillsFace", numbers: "NumbersFace", pacman: "PacmanFace" })[root.face] + ".qml")
        onLoaded: { root.attach(); attachTimer.restart(); }
        onStatusChanged: if (status === Loader.Error) console.warn("[FaceWorkspaces] failed to load", source)
    }
    Timer { id: attachTimer; interval: 0; onTriggered: root.attach() }

    MouseArea { // scroll to switch, right-click for the overview
        parent: root // not inside the pill's row layout
        width: root.width
        height: root.height
        z: 10
        acceptedButtons: Qt.RightButton
        onClicked: GlobalStates.overviewOpen = !GlobalStates.overviewOpen
        onWheel: wheel => {
            if (wheel.angleDelta.y < 0) Hyprland.dispatch(`hl.dsp.focus({workspace = "r+1"})`);
            else if (wheel.angleDelta.y > 0) Hyprland.dispatch(`hl.dsp.focus({workspace = "r-1"})`);
        }
    }
}
