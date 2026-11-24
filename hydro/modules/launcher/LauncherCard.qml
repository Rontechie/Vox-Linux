import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic as QC
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: ln
    property var host
    readonly property var pal: host.pal
    readonly property var cfg: host.cfg

    property string query: ""
    property string cat: "All"
    property bool editMode: false
    property string confirm: ""
    property string msg: ""
    property bool appeared: false
    property string favDragId: ""
    property var favDragOrder: []

    readonly property var results: host.filter(query, cat)
    readonly property string calcResult: host.calc(query)
    readonly property var favApps: host.favIds.map(id => host.appIndex[id])
    readonly property var effFavIds: favDragId !== "" ? favDragOrder : host.favIds
    readonly property int cols: [4, 5, 6][Math.max(0, Math.min(2, cfg.cols))]
    readonly property int iconPx: [40, 48, 56][Math.max(0, Math.min(2, cfg.iconSize))]

    implicitWidth: host.cardW; implicitHeight: host.cardH
    radius: 36; color: pal.surface
    border.width: 0
    Behavior on color { ColorAnimation { duration: 300 } }
    scale: appeared ? 1 : 0.94
    opacity: appeared ? 1 : 0
    Behavior on scale { NumberAnimation { duration: 440; easing.type: Easing.OutBack; easing.overshoot: 1.15 } }
    Behavior on opacity { NumberAnimation { duration: 240 } }
    Component.onCompleted: appeared = true

    function focusSearch() { sf.forceActiveFocus() }
    function activate() {
        if (calcResult !== "") { host.copyText(calcResult); msg = "Copied " + calcResult; msgT.restart(); return }
        if (results.length > 0) host.launchApp(results[0])
        else if (query.trim() !== "") host.runQuery(query)
    }
    function powerPress(name, needs) {
        if (!needs || !cfg.confirmPower || confirm === name) { confirm = ""; host.power(name); return }
        confirm = name; confirmT.restart()
    }
    function pin(id) {
        if (!host.toggleFav(id)) { msg = "Favorites are full (8)"; msgT.restart() }
    }
    Timer { id: confirmT; interval: 3000; onTriggered: ln.confirm = "" }
    Timer { id: msgT; interval: 2500; onTriggered: ln.msg = "" }
    Keys.onEscapePressed: host.closeAll()

    Item {
        id: dash
        anchors.fill: parent
        enabled: !host.settingsOpen
        x: host.settingsOpen ? -parent.width * 0.25 : 0
        opacity: host.settingsOpen ? 0 : 1
        visible: opacity > 0.01
        Behavior on x { NumberAnimation { duration: 350; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 250 } }

        ColumnLayout {
            anchors.fill: parent; anchors.margins: 16; spacing: 10

            RowLayout {
                Layout.fillWidth: true; spacing: 6
                Rectangle {
                    Layout.fillWidth: true; Layout.preferredHeight: 52; radius: 26
                    color: ln.pal.container; border.width: sf.activeFocus ? 2 : 0; border.color: ln.pal.primary
                    Behavior on border.width { NumberAnimation { duration: 150 } }
                    RowLayout {
                        anchors.fill: parent; anchors.margins: 8; spacing: 8
                        Item {
                            Layout.preferredWidth: 36; Layout.preferredHeight: 36
                            MorphShape { anchors.fill: parent; shape: sf.activeFocus ? "cookie9" : "circle"
                                color: ln.pal.primaryContainer; spin: sf.activeFocus; spinPeriod: 8000 }
                            GlyphIcon { anchors.centerIn: parent; width: 18; height: 18; glyph: "search"; color: ln.pal.fgOnPrimaryContainer }
                        }
                        QC.TextField {
                            id: sf
                            Layout.fillWidth: true; Layout.preferredHeight: 40
                            placeholderText: "Search apps or calculate"
                            color: ln.pal.fg; placeholderTextColor: ln.pal.onSurfaceVariant; font.pixelSize: 14; font.family: Appearance.font.family.main
                            background: Item {}
                            onTextChanged: { ln.query = text; gv.positionViewAtBeginning() }
                            onAccepted: ln.activate()
                            Keys.onEscapePressed: host.closeAll()
                        }
                        GBtn { pal: ln.pal; glyph: "close"; sz: 32; visible: sf.text !== ""; onClicked: { sf.text = ""; sf.forceActiveFocus() } }
                    }
                }
                GBtn { pal: ln.pal; glyph: ln.editMode ? "check" : "edit"; on: ln.editMode; onClicked: ln.editMode = !ln.editMode }
                GBtn { pal: ln.pal; glyph: "settings"; spin: true; onClicked: host.settingsOpen = true }
            }

            Rectangle {
                id: banner
                property real h: (ln.editMode || ln.msg !== "") ? 30 : 0
                Behavior on h { NumberAnimation { duration: 240; easing.type: Easing.OutCubic } }
                Layout.fillWidth: true; Layout.preferredHeight: h; visible: h > 0.5; clip: true
                radius: 15; color: ln.msg !== "" ? ln.pal.errorContainer : ln.pal.primaryContainer
                Behavior on color { ColorAnimation { duration: 200 } }
                StyledText { anchors.centerIn: parent; width: parent.width - 20; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight
                    text: ln.msg !== "" ? ln.msg : "Editing: tap + to pin an app, drag pinned apps to reorder"
                    font.pixelSize: 11; font.bold: true; color: ln.msg !== "" ? ln.pal.error : ln.pal.fgOnPrimaryContainer }
            }

            Item {
                id: favRow
                property real h: (cfg.showFavs && ln.query === "" && (ln.favApps.length > 0 || ln.editMode)) ? 76 : 0
                Behavior on h { NumberAnimation { duration: 260; easing.type: Easing.OutCubic } }
                Layout.fillWidth: true; Layout.preferredHeight: h; visible: h > 0.5; clip: false
                readonly property real cell: Math.min(80, width / Math.max(1, ln.effFavIds.length))

                Rectangle { anchors.fill: parent; radius: 24; color: ln.pal.container; opacity: 0.6 }
                StyledText {
                    visible: ln.favApps.length === 0 && ln.editMode; anchors.centerIn: parent
                    text: "No pinned apps yet"; font.pixelSize: 12; color: ln.pal.onSurfaceVariant
                }
                Repeater {
                    model: ln.favApps
                    delegate: Item {
                        id: fi
                        readonly property var a: modelData
                        readonly property bool dragging: ln.favDragId === a.id
                        property real sx: 0
                        width: favRow.cell; height: favRow.height
                        x: dragging ? sx + dh.translation.x : Math.max(0, ln.effFavIds.indexOf(a.id)) * favRow.cell
                        Behavior on x { enabled: !fi.dragging; NumberAnimation { duration: 280; easing.type: Easing.OutCubic } }
                        z: dragging ? 5 : 0
                        scale: dragging ? 1.12 : 1
                        Behavior on scale { SpringAnimation { spring: 5; damping: 0.4 } }
                        SequentialAnimation {
                            running: ln.editMode && !fi.dragging; loops: Animation.Infinite
                            onRunningChanged: if (!running) fi.rotation = 0
                            NumberAnimation { target: fi; property: "rotation"; to: 2; duration: 140 + (index % 3) * 30; easing.type: Easing.InOutSine }
                            NumberAnimation { target: fi; property: "rotation"; to: -2; duration: 140 + (index % 3) * 30; easing.type: Easing.InOutSine }
                        }
                        AppItem {
                            anchors.fill: parent
                            pal: ln.pal; app: fi.a; iconPx: 38; showLabel: false
                            shapeName: host.iconShapeName; hoverMorph: cfg.hoverMorph
                            editMode: ln.editMode; interactive: !ln.editMode; pinned: true
                            onLaunch: host.launchApp(fi.a)
                            onPinToggle: ln.pin(fi.a.id)
                        }
                        DragHandler {
                            id: dh
                            target: null
                            enabled: ln.editMode
                            xAxis.enabled: true; yAxis.enabled: false
                            onActiveChanged: {
                                if (active) { fi.sx = fi.x; ln.favDragOrder = host.favIds.slice(); ln.favDragId = fi.a.id }
                                else if (ln.favDragId === fi.a.id) { host.setFavs(ln.favDragOrder); ln.favDragId = "" }
                            }
                            onTranslationChanged: if (active) {
                                const n = ln.favDragOrder.length
                                let t = Math.round((fi.sx + translation.x) / favRow.cell)
                                t = Math.max(0, Math.min(n - 1, t))
                                const cur = ln.favDragOrder.indexOf(fi.a.id)
                                if (t !== cur) {
                                    const arr = ln.favDragOrder.slice()
                                    arr.splice(cur, 1); arr.splice(t, 0, fi.a.id)
                                    ln.favDragOrder = arr
                                }
                            }
                        }
                    }
                }
            }

            Item {
                id: chipRow
                property real h: (cfg.showCats && ln.query === "") ? 36 : 0
                Behavior on h { NumberAnimation { duration: 240; easing.type: Easing.OutCubic } }
                Layout.fillWidth: true; Layout.preferredHeight: h; visible: h > 0.5; clip: true
                Flickable {
                    id: chipFlick
                    anchors.fill: parent; contentWidth: chips.width; clip: true
                    flickableDirection: Flickable.HorizontalFlick; boundsBehavior: Flickable.StopAtBounds
                    WheelHandler {
                        onWheel: e => chipFlick.contentX = Math.max(0, Math.min(chipFlick.contentWidth - chipFlick.width, chipFlick.contentX - e.angleDelta.y))
                    }
                    Row {
                        id: chips; spacing: 6
                        Repeater {
                            model: host.groups
                            delegate: Rectangle {
                                readonly property bool sel: ln.cat === modelData
                                height: 34; width: ct.implicitWidth + 28; radius: sel ? 17 : 12
                                Behavior on radius { NumberAnimation { duration: 260; easing.type: Easing.OutBack; easing.overshoot: 1.5 } }
                                color: sel ? ln.pal.primary : ln.pal.containerHigh
                                Behavior on color { ColorAnimation { duration: 200 } }
                                scale: cm.pressed ? 0.93 : 1
                                Behavior on scale { SpringAnimation { spring: 5; damping: 0.4 } }
                                StyledText { id: ct; anchors.centerIn: parent; text: modelData; font.pixelSize: 12; font.bold: sel
                                    color: sel ? ln.pal.fgOnPrimary : ln.pal.fg }
                                MouseArea { id: cm; anchors.fill: parent; cursorShape: Qt.PointingHandCursor
                                    onClicked: { ln.cat = modelData; gv.positionViewAtBeginning() } }
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true; Layout.fillHeight: true

                Rectangle {
                    id: calcCard
                    property real h: ln.calcResult !== "" ? 56 : 0
                    Behavior on h { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
                    width: parent.width; height: h; visible: h > 0.5; clip: true
                    radius: 20; color: ln.pal.primaryContainer
                    scale: cc.pressed ? 0.97 : 1
                    Behavior on scale { SpringAnimation { spring: 5; damping: 0.4 } }
                    Row {
                        anchors.verticalCenter: parent.verticalCenter; x: 16; spacing: 12
                        StyledText { text: "="; font.pixelSize: 24; font.bold: true; color: ln.pal.fgOnPrimaryContainer; anchors.verticalCenter: parent.verticalCenter }
                        StyledText { text: ln.calcResult; font.pixelSize: 22; font.bold: true; color: ln.pal.fgOnPrimaryContainer; anchors.verticalCenter: parent.verticalCenter }
                    }
                    StyledText { anchors.right: parent.right; anchors.rightMargin: 16; anchors.verticalCenter: parent.verticalCenter
                        text: "tap to copy"; font.pixelSize: 11; color: ln.pal.fgOnPrimaryContainer; opacity: 0.7 }
                    MouseArea { id: cc; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: ln.activate() }
                }

                GridView {
                    id: gv
                    anchors.top: calcCard.visible ? calcCard.bottom : parent.top
                    anchors.topMargin: calcCard.visible ? 8 : 0
                    anchors.left: parent.left; anchors.right: parent.right; anchors.bottom: parent.bottom
                    clip: true; boundsBehavior: Flickable.StopAtBounds
                    model: ln.results
                    cellWidth: Math.floor(width / ln.cols)
                    cellHeight: (ln.iconPx + 18) + (cfg.showLabels ? 24 : 0) + 14
                    populate: Transition {
                        id: popT
                        SequentialAnimation {
                            PropertyAction { property: "opacity"; value: 0 }
                            PropertyAction { property: "scale"; value: 0.8 }
                            PauseAnimation { duration: Math.min(260, popT.ViewTransition.index * 12) }
                            ParallelAnimation {
                                NumberAnimation { property: "opacity"; to: 1; duration: 220 }
                                NumberAnimation { property: "scale"; to: 1; duration: 340; easing.type: Easing.OutBack; easing.overshoot: 1.6 }
                            }
                        }
                    }
                    delegate: Item {
                        width: gv.cellWidth; height: gv.cellHeight
                        AppItem {
                            anchors.fill: parent
                            pal: ln.pal; app: modelData; iconPx: ln.iconPx; showLabel: cfg.showLabels
                            shapeName: host.iconShapeName; hoverMorph: cfg.hoverMorph
                            editMode: ln.editMode; pinned: host.favIds.indexOf(modelData.id) >= 0
                            selected: ln.query !== "" && index === 0
                            onLaunch: host.launchApp(modelData)
                            onPinToggle: ln.pin(modelData.id)
                        }
                    }
                }

                Column {
                    anchors.centerIn: parent; spacing: 10
                    opacity: (ln.results.length === 0 && ln.calcResult === "") ? 1 : 0
                    visible: opacity > 0.01
                    Behavior on opacity { NumberAnimation { duration: 250 } }
                    MorphShape { width: 72; height: 72; anchors.horizontalCenter: parent.horizontalCenter
                        shape: host.apps.length === 0 ? "cookie9" : "burst"; color: ln.pal.containerHigh; spin: true; spinPeriod: 12000 }
                    StyledText { anchors.horizontalCenter: parent.horizontalCenter; font.pixelSize: 14; color: ln.pal.fg
                        text: host.apps.length === 0 ? "Loading apps…" : "No apps found" }
                    StyledText { anchors.horizontalCenter: parent.horizontalCenter; font.pixelSize: 11; color: ln.pal.onSurfaceVariant
                        visible: host.apps.length > 0 && ln.query.trim() !== ""; text: "Press Enter to search the web" }
                }
            }

            Item {
                id: powerBar
                property real h: cfg.showPower ? 44 : 0
                Behavior on h { NumberAnimation { duration: 240; easing.type: Easing.OutCubic } }
                Layout.fillWidth: true; Layout.preferredHeight: h; visible: h > 0.5; clip: true
                RowLayout {
                    anchors.fill: parent; spacing: 6
                    Item {
                        Layout.preferredWidth: 40; Layout.preferredHeight: 40
                        MorphShape { anchors.fill: parent; shape: "cookie6"; color: ln.pal.primaryContainer; spin: true; spinPeriod: 20000 }
                        StyledText { anchors.centerIn: parent; text: host.userName ? host.userName.charAt(0).toUpperCase() : "?"
                            font.pixelSize: 16; font.bold: true; color: ln.pal.fgOnPrimaryContainer }
                    }
                    StyledText { text: host.userName; visible: host.cardW >= 430 || ln.confirm === ""; font.pixelSize: 13; font.bold: true
                        color: ln.pal.fg; Layout.fillWidth: true; elide: Text.ElideRight; Layout.leftMargin: 4 }
                    Item { Layout.fillWidth: true; visible: !(host.cardW >= 430 || ln.confirm === "") }
                    PowerBtn { pal: ln.pal; glyph: "lock"; onClicked: ln.powerPress("lock", false) }
                    PowerBtn { pal: ln.pal; glyph: "sleep"; onClicked: ln.powerPress("sleep", false) }
                    PowerBtn { pal: ln.pal; glyph: "restart"; confirming: ln.confirm === "restart"; onClicked: ln.powerPress("restart", true) }
                    PowerBtn { pal: ln.pal; glyph: "logout"; confirming: ln.confirm === "logout"; onClicked: ln.powerPress("logout", true) }
                    PowerBtn { pal: ln.pal; glyph: "power"; confirming: ln.confirm === "shutdown"; onClicked: ln.powerPress("shutdown", true) }
                }
            }
        }
    }

    SettingsPage {
        width: parent.width; height: parent.height
        pal: ln.pal; cfg: ln.cfg
        enabled: host.settingsOpen
        x: host.settingsOpen ? 0 : parent.width * 0.25
        opacity: host.settingsOpen ? 1 : 0
        visible: opacity > 0.01
        Behavior on x { NumberAnimation { duration: 350; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 250 } }
        onBack: host.settingsOpen = false
        onRescan: host.scanApps()
        onClearRecent: host.cfg.recent = ""
        onAssignShortcut: host.assignShortcut()
    }
}
