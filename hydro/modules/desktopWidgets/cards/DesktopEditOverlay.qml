pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import Quickshell
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.desktopWidgets.ui

Item {
    id: root
    visible: HwConfig.editMode || toolbar.opacity > 0.01
    focus: HwConfig.editMode
    Keys.onEscapePressed: HwConfig.editMode = false

    readonly property var catalog: [
        { name: "media", title: Translation.tr("Media player"), desc: Translation.tr("Now playing with cover art"), icon: "music_note", shape: MaterialShape.Shape.Cookie9Sided, w: 380, h: 170 },
        { name: "player", title: Translation.tr("Player + lyrics"), desc: Translation.tr("Now playing with synced lyrics below"), icon: "queue_music", shape: MaterialShape.Shape.Cookie9Sided, w: 400, h: 380 },
        { name: "lyrics", title: Translation.tr("Lyrics"), desc: Translation.tr("Synced lyrics of the current song"), icon: "lyrics", shape: MaterialShape.Shape.Clover4Leaf, w: 380, h: 280 },
        { name: "weather", title: Translation.tr("Weather"), desc: Translation.tr("Conditions and a 3 day forecast"), icon: "partly_cloudy_day", shape: MaterialShape.Shape.Sunny, w: 360, h: 340 },
        { name: "system", title: Translation.tr("System"), desc: Translation.tr("CPU, memory and storage"), icon: "monitoring", shape: MaterialShape.Shape.Gem, w: 440, h: 160 },
        { name: "gauge", title: Translation.tr("Gauge"), desc: Translation.tr("One metric as a shaped gauge"), icon: "speed", shape: MaterialShape.Shape.Flower, w: 200, h: 200 },
        { name: "stopwatch", title: Translation.tr("Stopwatch"), desc: Translation.tr("Start, stop and lap"), icon: "timer", shape: MaterialShape.Shape.Pentagon, w: 300, h: 280 },
        { name: "cava", title: Translation.tr("Audio visualizer"), desc: Translation.tr("Bars or a wave along the screen edge"), icon: "graphic_eq", shape: MaterialShape.Shape.SoftBurst, w: 0, h: 0 }
    ]

    property string filter: "all"      // all | added | available
    property string query: ""
    readonly property var shown: catalog.filter(c => {
        const on = HwConfig.isEnabled(c.name);
        if (filter === "added" && !on) return false;
        if (filter === "available" && on) return false;
        const q = query.trim().toLowerCase();
        return q.length === 0 || c.title.toLowerCase().indexOf(q) >= 0 || c.desc.toLowerCase().indexOf(q) >= 0;
    })

    function add(c) {
        HwConfig.setEnabled(c.name, true);
        const w = HwConfig.widget(c.name);
        if (w) {
            const n = HwConfig.widgetNames.filter(x => x !== c.name && HwConfig.isEnabled(x)).length;
            const g = HwLayer.snapCell;
            w.anchor = "custom";
            w.x = Math.round((root.width / 2 - c.w / 2 + 24 * n) / g) * g;
            w.y = Math.round((root.height / 2 - c.h / 2 + 24 * n) / g) * g;
            HwConfig.selected = c.name;
        }
    }

    readonly property real insetTop: HwLayer.barEdge === "top" ? HwLayer.topBaseH + 8 : 0
    readonly property real insetBottom: HwLayer.barEdge === "bottom" ? HwLayer.topBaseH + 8 : 0
    component SpringX: NumberAnimation { duration: 460; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve }

    Rectangle {
        id: toolbar
        anchors.horizontalCenter: parent.horizontalCenter
        y: HwConfig.editMode ? root.insetTop + 22 : -height - 20
        opacity: HwConfig.editMode ? 1 : 0
        Behavior on y { SpringX {} }
        Behavior on opacity { NumberAnimation { duration: 200 } }
        height: 60
        width: tbRow.implicitWidth + 16
        radius: 30
        color: HwM3.surfaceContainer
        border.width: 1
        border.color: HwM3.alpha(HwM3.inkSurface, 0.10)

        component TbButton: Rectangle {
            id: b
            property string icon
            property string label
            property bool active: false
            property bool prominent: false
            signal clicked
            height: 44
            width: label.length > 0 ? lbl.implicitWidth + 22 + 8 + 36 : 44
            radius: ma.pressed ? 12 : (active ? 16 : 22)      // shape morph: pill -> squircle when pressed / active
            scale: ma.pressed ? 0.94 : 1
            color: prominent ? HwM3.primary : (active ? HwM3.secondaryContainer : (ma.containsMouse ? HwM3.alpha(HwM3.inkSurface, 0.10) : "transparent"))
            Behavior on radius { NumberAnimation { duration: 260; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve } }
            Behavior on scale { NumberAnimation { duration: 160 } }
            Behavior on color { ColorAnimation { duration: 140 } }
            Row {
                anchors.centerIn: parent
                spacing: 8
                MaterialSymbol {
                    anchors.verticalCenter: parent.verticalCenter
                    text: b.icon
                    iconSize: 22
                    fill: b.active || b.prominent ? 1 : 0
                    color: b.prominent ? HwM3.c.m3onPrimary : (b.active ? HwM3.inkSecondaryContainer : HwM3.inkSurface)
                }
                Text {
                    id: lbl
                    visible: b.label.length > 0
                    anchors.verticalCenter: parent.verticalCenter
                    text: b.label
                    font.family: HwState.fontPrimary
                    font.pixelSize: 15
                    font.weight: Font.Medium
                    color: b.prominent ? HwM3.c.m3onPrimary : HwM3.inkSurface
                }
            }
            MouseArea { id: ma; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: b.clicked() }
        }

        Row {
            id: tbRow
            anchors.centerIn: parent
            spacing: 6
            TbButton { icon: "widgets"; label: Translation.tr("Widgets"); active: HwConfig.galleryOpen; onClicked: HwConfig.galleryOpen = !HwConfig.galleryOpen }
            TbButton { icon: "grid_on"; active: HwConfig.general.snapToGrid; onClicked: HwConfig.general.snapToGrid = !HwConfig.general.snapToGrid }
            Rectangle { width: 1; height: 28; anchors.verticalCenter: parent.verticalCenter; color: HwM3.alpha(HwM3.inkSurface, 0.14) }
            TbButton { icon: "check"; label: Translation.tr("Done"); prominent: true; onClicked: HwConfig.editMode = false }
        }
    }

    Rectangle {
        id: drawer
        readonly property bool open: HwConfig.editMode && HwConfig.galleryOpen
        width: 400
        y: root.insetTop + 96
        height: parent.height - y - 24 - root.insetBottom
        x: open ? 24 : -width - 40
        opacity: open ? 1 : 0
        Behavior on x { SpringX {} }
        Behavior on opacity { NumberAnimation { duration: 200 } }
        visible: opacity > 0.01
        radius: 32
        color: HwM3.surfaceContainer
        border.width: 1
        border.color: HwM3.alpha(HwM3.inkSurface, 0.10)

        MouseArea { anchors.fill: parent; acceptedButtons: Qt.AllButtons; onWheel: wheel => wheel.accepted = true }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                Text {
                    Layout.fillWidth: true
                    text: Translation.tr("Widgets")
                    font.family: HwState.fontPrimary
                    font.pixelSize: 28
                    font.weight: Font.DemiBold
                    color: HwM3.inkSurface
                }
                Rectangle {
                    width: 40; height: 40
                    radius: closeMa.pressed ? 12 : 20
                    Behavior on radius { NumberAnimation { duration: 200; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve } }
                    color: closeMa.containsMouse ? HwM3.alpha(HwM3.inkSurface, 0.12) : "transparent"
                    MaterialSymbol { anchors.centerIn: parent; text: "close"; iconSize: 22; color: HwM3.inkSurface }
                    MouseArea { id: closeMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor; onClicked: HwConfig.galleryOpen = false }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 48
                radius: 24
                color: HwM3.alpha(HwM3.inkSurface, 0.07)
                border.width: search.activeFocus ? 2 : 0
                border.color: HwM3.primary
                RowLayout {
                    anchors { fill: parent; leftMargin: 16; rightMargin: 12 }
                    spacing: 10
                    MaterialSymbol { text: "search"; iconSize: 22; color: HwM3.alpha(HwM3.inkSurface, 0.7) }
                    TextInput {
                        id: search
                        Layout.fillWidth: true
                        verticalAlignment: TextInput.AlignVCenter
                        font.family: HwState.fontSecondary
                        font.pixelSize: 16
                        color: HwM3.inkSurface
                        clip: true
                        selectByMouse: true
                        onTextChanged: root.query = text
                        Keys.onEscapePressed: { if (text.length > 0) text = ""; else HwConfig.editMode = false; }
                        Text {
                            visible: search.text.length === 0
                            anchors.verticalCenter: parent.verticalCenter
                            text: Translation.tr("Search widgets…")
                            font: search.font
                            color: HwM3.alpha(HwM3.inkSurface, 0.5)
                        }
                    }
                }
            }

            Row {
                spacing: 8
                Repeater {
                    model: [
                        { id: "all", label: Translation.tr("All") },
                        { id: "added", label: Translation.tr("Added") },
                        { id: "available", label: Translation.tr("Available") }
                    ]
                    delegate: Rectangle {
                        id: chip
                        required property var modelData
                        readonly property bool on: root.filter === modelData.id
                        height: 36
                        width: chipText.implicitWidth + 28
                        radius: chipMa.pressed ? 10 : (on ? 14 : 18)
                        Behavior on radius { NumberAnimation { duration: 240; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve } }
                        color: on ? HwM3.secondaryContainer : "transparent"
                        border.width: on ? 0 : 1
                        border.color: HwM3.alpha(HwM3.inkSurface, 0.22)
                        Behavior on color { ColorAnimation { duration: 140 } }
                        Text {
                            id: chipText
                            anchors.centerIn: parent
                            text: chip.modelData.label
                            font.family: HwState.fontPrimary
                            font.pixelSize: 14
                            font.weight: Font.Medium
                            color: chip.on ? HwM3.inkSecondaryContainer : HwM3.inkSurface
                        }
                        MouseArea { id: chipMa; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: root.filter = chip.modelData.id }
                    }
                }
            }

            Flickable {
                Layout.fillWidth: true
                Layout.fillHeight: true
                contentWidth: width
                contentHeight: grid.implicitHeight
                clip: true
                boundsBehavior: Flickable.StopAtBounds

                Grid {
                    id: grid
                    width: parent.width
                    columns: 2
                    spacing: 12
                    Repeater {
                        model: root.shown
                        delegate: Rectangle {
                            id: card
                            required property var modelData
                            required property int index
                            readonly property bool on: HwConfig.isEnabled(modelData.name)
                            width: (grid.width - grid.spacing) / 2
                            height: 176
                            radius: cardMa.pressed ? 16 : (on ? 24 : 28)
                            color: on ? HwM3.primaryContainer : HwM3.alpha(HwM3.inkSurface, 0.07)

                            property bool entered: false
                            opacity: entered ? 1 : 0
                            transform: Translate { y: card.entered ? 0 : 26; Behavior on y { SpringX {} } }
                            scale: cardMa.pressed ? 0.95 : 1
                            Behavior on opacity { NumberAnimation { duration: 220 } }
                            Behavior on scale { NumberAnimation { duration: 140 } }
                            Behavior on radius { NumberAnimation { duration: 300; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve } }
                            Behavior on color { ColorAnimation { duration: 200 } }
                            Timer { id: enter; interval: 30 + card.index * 45; onTriggered: card.entered = true }
                            Connections {
                                target: drawer
                                function onOpenChanged() {
                                    card.entered = false;
                                    if (drawer.open) enter.restart();
                                }
                            }
                            Component.onCompleted: { if (drawer.open) enter.restart(); }

                            ColumnLayout {
                                anchors { fill: parent; margins: 14 }
                                spacing: 6
                                Item {
                                    Layout.alignment: Qt.AlignHCenter
                                    implicitWidth: 72; implicitHeight: 72
                                    MaterialShapeWrappedMaterialSymbol {
                                        anchors.centerIn: parent
                                        shape: card.modelData.shape
                                        implicitSize: card.on ? 72 : 64
                                        Behavior on implicitSize { NumberAnimation { duration: 320; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve } }
                                        text: card.modelData.icon
                                        iconSize: 30
                                        color: card.on ? HwM3.primary : HwM3.secondaryContainer
                                        colSymbol: card.on ? HwM3.c.m3onPrimary : HwM3.inkSecondaryContainer
                                    }
                                    Rectangle {
                                        x: parent.width - 20; y: -2
                                        width: 24; height: 24; radius: 12
                                        color: HwM3.primary
                                        scale: card.on ? 1 : 0
                                        Behavior on scale { NumberAnimation { duration: 360; easing.type: Easing.BezierSpline; easing.bezierCurve: HwM3.springCurve } }
                                        MaterialSymbol { anchors.centerIn: parent; text: "check"; iconSize: 16; color: HwM3.c.m3onPrimary }
                                    }
                                }
                                Text {
                                    Layout.fillWidth: true
                                    horizontalAlignment: Text.AlignHCenter
                                    text: card.modelData.title
                                    font.family: HwState.fontPrimary
                                    font.pixelSize: 16
                                    font.weight: Font.DemiBold
                                    color: card.on ? HwM3.inkPrimaryContainer : HwM3.inkSurface
                                    elide: Text.ElideRight
                                }
                                Text {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    horizontalAlignment: Text.AlignHCenter
                                    text: card.on ? Translation.tr("Added · tap to remove") : card.modelData.desc
                                    wrapMode: Text.Wrap
                                    maximumLineCount: 2
                                    elide: Text.ElideRight
                                    font.family: HwState.fontSecondary
                                    font.pixelSize: 12
                                    color: card.on ? HwM3.alpha(HwM3.inkPrimaryContainer, 0.8) : HwM3.alpha(HwM3.inkSurface, 0.65)
                                }
                            }
                            MouseArea {
                                id: cardMa
                                anchors.fill: parent
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    if (card.on) {
                                        HwConfig.setEnabled(card.modelData.name, false);
                                        if (HwConfig.selected === card.modelData.name) HwConfig.selected = "";
                                    } else {
                                        root.add(card.modelData);
                                    }
                                }
                            }
                        }
                    }
                }

                Text {
                    visible: root.shown.length === 0
                    anchors.centerIn: parent
                    text: Translation.tr("No widgets match")
                    font.family: HwState.fontSecondary
                    font.pixelSize: 15
                    color: HwM3.alpha(HwM3.inkSurface, 0.6)
                }
            }
        }
    }

    onVisibleChanged: if (visible) forceActiveFocus()
}
