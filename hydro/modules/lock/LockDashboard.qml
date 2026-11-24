import QtQuick
import QtQuick.Layouts
import qs.modules.common

Item {
    id: root
    required property var surface           // the LockSurface: provides placeX / placeY
    readonly property var lay: surface.lay
    readonly property real panelWidth: Math.min(360, width * 0.24)
    readonly property real margin: 48

    PanelLeft {
        id: leftCol
        readonly property bool legacy: root.lay.panelLeft.anchor === "default"
        anchors.left: legacy ? parent.left : undefined
        anchors.leftMargin: root.margin
        anchors.verticalCenter: legacy ? parent.verticalCenter : undefined
        x: legacy ? 0 : root.surface.placeX(root.lay.panelLeft.anchor, root.lay.panelLeft.x, width)
        y: legacy ? 0 : root.surface.placeY(root.lay.panelLeft.anchor, root.lay.panelLeft.y, height)
        width: root.panelWidth
    }

    PanelRight {
        id: rightCol
        readonly property bool legacy: root.lay.panelRight.anchor === "default"
        anchors.right: legacy ? parent.right : undefined
        anchors.rightMargin: root.margin
        anchors.verticalCenter: legacy ? parent.verticalCenter : undefined
        x: legacy ? 0 : root.surface.placeX(root.lay.panelRight.anchor, root.lay.panelRight.x, width)
        y: legacy ? 0 : root.surface.placeY(root.lay.panelRight.anchor, root.lay.panelRight.y, height)
        width: root.panelWidth
    }
}
