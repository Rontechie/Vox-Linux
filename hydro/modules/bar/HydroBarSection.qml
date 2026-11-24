import QtQuick
import qs
import qs.modules.common

Item {
    id: root
    required property string sectionName   // "left" | "center" | "right"
    property var ids: []                    // widget ids, in order
    property Item dragSpace                 // item whose coordinates drop positions are reported in
    readonly property bool editing: GlobalStates.barEditMode
    readonly property var isl: Config.options.bar.islands
    readonly property real islandPad: isl.enable ? isl.padding : 0

    signal dropped(string widgetId, string fromSection, real centerX)

    implicitWidth: row.implicitWidth
    implicitHeight: 40

    function slotIndexAt(centerX, excludeId) {
        let idx = 0;
        for (let i = 0; i < rep.count; i++) {
            const it = rep.itemAt(i);
            if (!it || it.widgetId === excludeId) continue;
            const cx = it.mapToItem(root.dragSpace, it.width / 2, 0).x;
            if (cx < centerX) idx++;
        }
        return idx;
    }

    Row {
        id: row
        anchors.verticalCenter: parent.verticalCenter
        spacing: root.isl.enable ? root.isl.spacing : 10

        Repeater {
            id: rep
            model: root.ids

            delegate: Item {
                id: cell
                required property string modelData
                readonly property string widgetId: modelData
                readonly property bool isHidden: Array.from(Config.options.bar.hydroLayout.hidden).indexOf(modelData) >= 0
                visible: !isHidden
                width: (isHidden || widget.implicitWidth <= 0) ? 0 : widget.implicitWidth + root.islandPad * 2
                height: root.height

                Item { // holder: this is what moves while dragging
                    id: holder
                    width: cell.width
                    height: cell.height
                    z: dragArea.drag.active ? 100 : 0
                    scale: dragArea.drag.active ? 1.06 : 1
                    Behavior on x { enabled: !dragArea.drag.active; animation: Appearance.animation.elementMove.numberAnimation.createObject(this) }
                    Behavior on scale { animation: Appearance.animation.elementMoveFast.numberAnimation.createObject(this) }

                    Rectangle { // the island: one rounded plate per widget
                        id: island
                        anchors.centerIn: parent
                        width: parent.width
                        height: Math.round(Appearance.sizes.baseBarHeight * root.isl.thickness)
                        radius: root.isl.radiusAuto ? height / 2 * Math.min(1, Appearance.rScale) : Math.min(root.isl.radius, height / 2)
                        color: Appearance.colors.colLayer0
                        border.width: root.isl.borderWidth
                        border.color: Appearance.m3colors.m3outlineVariant
                        opacity: root.isl.enable && cell.width > 0 ? 1 : 0
                        visible: opacity > 0
                        Behavior on opacity { NumberAnimation { duration: 150 } }
                    }

                    HydroBarWidget {
                        id: widget
                        anchors.centerIn: parent
                        widgetId: cell.widgetId
                    }

                    Rectangle { // edit-mode outline
                        anchors.centerIn: widget
                        width: widget.width + 8
                        height: widget.height + 8
                        radius: 14
                        color: dragArea.drag.active ? "#26ffffff" : "transparent"
                        border.width: 1.5
                        border.color: Appearance.colors.colPrimary
                        opacity: root.editing ? 1 : 0
                        visible: opacity > 0
                        Behavior on opacity { NumberAnimation { duration: 180 } }
                    }
                }

                MouseArea { // edit mode only: grabs presses so widgets don't click while moving
                    id: dragArea
                    anchors.fill: parent
                    z: 50
                    enabled: root.editing
                    visible: root.editing
                    drag.target: holder
                    drag.axis: Drag.XAxis
                    cursorShape: drag.active ? Qt.ClosedHandCursor : Qt.OpenHandCursor
                    onReleased: {
                        const centerX = holder.mapToItem(root.dragSpace, holder.width / 2, 0).x;
                        root.dropped(cell.widgetId, root.sectionName, centerX);
                        holder.x = 0;
                    }
                }
            }
        }
    }
}
