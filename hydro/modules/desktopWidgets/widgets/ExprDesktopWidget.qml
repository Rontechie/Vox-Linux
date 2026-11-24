import QtQuick
import qs.modules.desktopWidgets.ui
import qs.modules.common.widgets

DesktopWidgetFrame {
    id: edw
    property string wType: ""
    property real baseW: 220
    property real baseH: 220
    property Component face: null
    readonly property var wc: HwConfig.widget(wType)
    readonly property real cell: HwLayer.gridCell
    readonly property real sc: wc ? wc.scale : 1
    dwOn: wc ? wc.enable === true : false
    readonly property bool live: visible && dwOn && !HwState.lockScreenActive && !HwState.wpFullscreenActive
    readonly property string anchorName: wc && wc.anchor ? wc.anchor : "custom"
    readonly property real edge: HwConfig.general.edgeMargin
    readonly property real insetTop: HwLayer.barEdge === "top" ? HwLayer.topBaseH : 0
    readonly property real insetBottom: HwLayer.barEdge === "bottom" ? HwLayer.topBaseH : 0
    readonly property real fx: anchorName.indexOf("left") >= 0 ? 0 : (anchorName.indexOf("right") >= 0 ? 1 : 0.5)
    readonly property real fy: anchorName.indexOf("top") >= 0 ? 0 : (anchorName.indexOf("bottom") >= 0 ? 1 : 0.5)
    readonly property real homeX: anchorName === "custom" ? (wc ? wc.x : 0)
        : edge + fx * Math.max(0, (parent ? parent.width : 0) - 2 * edge - width)
    readonly property real homeY: anchorName === "custom" ? (wc ? wc.y : 0)
        : insetTop + edge + fy * Math.max(0, (parent ? parent.height : 0) - insetTop - insetBottom - 2 * edge - height)
    x: homeX
    y: homeY
    width:  Math.ceil((baseW * sc) / cell) * cell
    height: Math.ceil((baseH * sc) / cell) * cell
    dragging: dragArea.drag.active

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.RightButton
        onClicked: HwLayer.menu_openFor(edw, edw.wType)
    }

    Loader {
        anchors.fill: parent
        anchors.margins: HwLayer.widgetGap
        active: edw.visible
        sourceComponent: edw.face
    }

    readonly property bool selected: HwState.desktopEditMode && HwConfig.selected === wType

    MouseArea {
        id: dragArea
        anchors.fill: parent
        z: 10
        visible: HwState.desktopEditMode
        enabled: HwState.desktopEditMode
        acceptedButtons: Qt.LeftButton
        cursorShape: drag.active ? Qt.ClosedHandCursor : Qt.OpenHandCursor
        drag.target: edw
        drag.axis: Drag.XAndYAxis
        onPressed: HwConfig.selected = edw.wType
        onReleased: {
            const c = HwLayer.snapCell;
            const nx = Math.max(0, Math.round(edw.x / c) * c);
            const ny = Math.max(0, Math.round(edw.y / c) * c);
            if (edw.wc) edw.wc.anchor = "custom"; // dragging it means "put it here"
            HwConfig.setPosition(edw.wType, nx, ny);
            edw.x = Qt.binding(() => edw.homeX);
            edw.y = Qt.binding(() => edw.homeY);
        }

        Rectangle {
            anchors.fill: parent
            anchors.margins: edw.selected ? -4 : 0
            Behavior on anchors.margins { NumberAnimation { duration: 380; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve } }
            color: edw.selected ? HwM3.alpha(HwM3.primary, 0.10) : (dragArea.containsMouse ? HwM3.alpha(HwM3.primary, 0.06) : "transparent")
            radius: edw.selected ? 32 : 28
            border.width: edw.selected ? 3 : 2
            border.color: edw.selected ? HwM3.primary : HwM3.alpha(HwM3.primary, 0.45)
            Behavior on color { ColorAnimation { duration: 160 } }
            Behavior on radius { NumberAnimation { duration: 300; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve } }
        }
        hoverEnabled: true
    }

    Rectangle {
        id: handle
        z: 12
        visible: edw.selected || handleOpacity.running
        opacity: edw.selected ? 1 : 0
        scale: handleArea.pressed ? 1.25 : (edw.selected ? 1 : 0.2)
        Behavior on opacity { NumberAnimation { id: handleOpacity; duration: 160 } }
        Behavior on scale { NumberAnimation { duration: 340; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve } }
        width: 26; height: 26
        radius: handleArea.pressed ? 8 : 13
        Behavior on radius { NumberAnimation { duration: 140 } }
        x: parent.width - width / 2 - 4
        y: parent.height - height / 2 - 4
        color: HwM3.primary
        border.width: 3
        border.color: HwM3.surfaceContainer
        MaterialSymbol {
            anchors.centerIn: parent
            text: "open_in_full"
            iconSize: 14
            color: HwM3.c.m3onPrimary
        }
        MouseArea {
            id: handleArea
            anchors.fill: parent
            anchors.margins: -8
            cursorShape: Qt.SizeFDiagCursor
            preventStealing: true
            onPositionChanged: mouse => {
                if (!pressed || !edw.wc) return;
                const p = mapToItem(edw.parent, mouse.x, mouse.y);
                const raw = (p.x - edw.x) / edw.baseW;
                edw.wc.scale = Math.max(0.5, Math.min(2.5, Math.round(raw * 20) / 20));
            }
        }
    }

    Rectangle {
        id: mini
        z: 12
        visible: opacity > 0.01
        opacity: edw.selected ? 1 : 0
        readonly property bool below: edw.y < 64
        y: (below ? parent.height + 12 : -height - 12) + (edw.selected ? 0 : (below ? -8 : 8))
        x: (parent.width - width) / 2
        Behavior on opacity { NumberAnimation { duration: 160 } }
        Behavior on y { NumberAnimation { duration: 340; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve } }
        width: miniRow.implicitWidth + 12
        height: 40
        radius: 20
        color: HwM3.surfaceContainer
        border.width: 1
        border.color: HwM3.alpha(HwM3.inkSurface, 0.12)

        Row {
            id: miniRow
            anchors.centerIn: parent
            spacing: 4
            Repeater {
                model: [
                    { g: "restart_alt", act: "reset" },
                    { g: "close", act: "remove" }
                ]
                delegate: Rectangle {
                    id: mb
                    required property var modelData
                    width: 44; height: 30
                    radius: mbArea.pressed ? 9 : 15
                    scale: mbArea.pressed ? 0.92 : 1
                    color: mbArea.containsMouse ? (modelData.act === "remove" ? HwM3.alpha(HwM3.error, 0.22) : HwM3.alpha(HwM3.primary, 0.20)) : HwM3.alpha(HwM3.inkSurface, 0.06)
                    Behavior on radius { NumberAnimation { duration: 140; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve } }
                    Behavior on scale { NumberAnimation { duration: 140 } }
                    Behavior on color { ColorAnimation { duration: 120 } }
                    MaterialSymbol {
                        anchors.centerIn: parent
                        text: mb.modelData.g
                        iconSize: 18
                        color: mb.modelData.act === "remove" ? HwM3.error : HwM3.inkSurface
                    }
                    MouseArea {
                        id: mbArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (mb.modelData.act === "reset") { if (edw.wc) edw.wc.scale = 1; }
                            else { HwConfig.setEnabled(edw.wType, false); HwConfig.selected = ""; }
                        }
                    }
                }
            }
        }
    }
}
