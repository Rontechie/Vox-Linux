import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

Scope {
    id: root

    required property var core
    readonly property var cfg: Config.options.launcher
    readonly property var sc: Config.options.launcher.search
    readonly property bool wanted: GlobalStates.launcherOpen && cfg.style === "search"

    property string query: ""
    property int selected: 0

    readonly property var st: SearchPillState
    readonly property var targetScreen: Quickshell.screens.find(s => s.name === st.screenName) ?? Quickshell.screens[0]
    readonly property real sw: targetScreen?.width ?? 1920
    readonly property real sh: targetScreen?.height ?? 1080
    readonly property bool flip: st.known ? st.bottom : Config.options.bar.bottom
    readonly property real pillH: Math.max(32, st.known ? st.h : 34)
    readonly property real collapsedW: st.known ? st.w : sc.pillWidth
    readonly property real fullW: Math.max(sc.width, collapsedW)
    readonly property real islandX: Math.max(8, Math.min(st.known ? st.x : (sw - fullW) / 2, sw - fullW - 8))
    readonly property real barClear: Config.options.bar.autoHide.enable ? 0 : Appearance.sizes.barHeight
    readonly property real pillY: flip ? sh - barClear - 8 - pillH : barClear + 8
    readonly property int rowH: 54
    readonly property int rows: Math.max(3, Math.min(12, sc.rows))

    readonly property var results: {
        const q = query.trim();
        const out = [];
        if (q === "") {
            const ids = core.recentIds.length > 0 ? core.recentIds : core.favIds;
            for (const id of ids) {
                const a = core.appById(id);
                if (a) out.push({ kind: "app", title: a.name, sub: a.group, app: a });
            }
            return out.slice(0, rows);
        }
        const c = core.calc(q);
        if (c !== "")
            out.push({ kind: "calc", title: c, sub: q + " =", icon: "calculate" });
        for (const a of core.filter(q, "All").slice(0, 40))
            out.push({ kind: "app", title: a.name, sub: a.group, app: a });
        out.push({ kind: "web", title: Translation.tr("Search the web for “%1”").replace("%1", q), sub: Translation.tr("Opens your browser"), icon: "travel_explore" });
        return out;
    }
    onResultsChanged: selected = 0

    function activate(item) {
        if (!item) return;
        if (item.kind === "app") core.launchApp(item.app);
        else if (item.kind === "calc") { core.copyText(item.title); core.closeAll(); }
        else if (item.kind === "web") core.runQuery(query.trim());
    }

    PanelWindow {
        id: win

        readonly property real pad: Appearance.sizes.elevationMargin + Appearance.sizes.hyprlandGapsOut
        readonly property real leftM: Math.max(0, root.islandX - pad)
        readonly property real topM: Math.max(0, root.pillY - pad)
        readonly property real botM: Math.max(0, root.sh - (root.pillY + root.pillH) - pad)
        property bool armed: false
        property bool shown: false
        property bool keep: false

        screen: root.targetScreen
        visible: root.wanted || keep
        color: "transparent"
        exclusionMode: ExclusionMode.Ignore
        implicitWidth: root.fullW + pad * 2
        implicitHeight: root.pillH + root.rows * root.rowH + 24 + pad * 2
        WlrLayershell.namespace: "quickshell:searchlauncher"
        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.keyboardFocus: root.wanted ? WlrKeyboardFocus.OnDemand : WlrKeyboardFocus.None
        anchors {
            left: true
            top: !root.flip
            bottom: root.flip
        }
        margins {
            left: leftM
            top: topM
            bottom: botM
        }

        Connections {
            target: root
            function onWantedChanged() {
                if (root.wanted) {
                    root.query = "";
                    field.text = "";
                    win.keep = false;
                    keepTimer.stop();
                    win.shown = false;
                    showTimer.restart();
                    grabDelay.restart();
                    Qt.callLater(() => field.forceActiveFocus());
                } else {
                    win.shown = false;
                    win.keep = true; // let the island shrink back into the pill
                    keepTimer.restart();
                    grabDelay.stop();
                    win.armed = false;
                    GlobalFocusGrab.removeDismissable(win);
                }
            }
        }
        Timer {
            id: keepTimer
            interval: 320
            onTriggered: win.keep = false
        }
        Timer {
            id: showTimer
            interval: 16
            onTriggered: win.shown = true
        }
        Timer {
            id: grabDelay
            interval: 200
            onTriggered: {
                if (root.wanted) {
                    win.armed = true;
                    GlobalFocusGrab.addDismissable(win);
                }
            }
        }
        Connections {
            target: GlobalFocusGrab
            function onDismissed() {
                if (win.armed)
                    root.core.closeAll();
            }
        }

        StyledRectangularShadow {
            target: island
            visible: win.shown
        }

        Rectangle {
            id: island

            readonly property bool hasResults: win.shown && root.results.length > 0
            readonly property real listH: Math.min(root.rows, root.results.length) * root.rowH + 16
            readonly property real offX: root.islandX - win.leftM
            readonly property real offY: root.pillY - win.topM
            readonly property real offB: root.sh - (root.pillY + root.pillH) - win.botM

            x: offX
            y: root.flip ? parent.height - offB - height : offY
            width: win.shown ? root.fullW : root.collapsedW
            height: root.pillH + (hasResults ? listH : 0)
            radius: hasResults ? 26 : root.pillH / 2
            color: win.shown ? Qt.alpha(Appearance.m3colors.m3surfaceContainerHigh, 0.97) : Appearance.colors.colSecondaryContainer
            border.width: 1
            border.color: win.shown ? Qt.rgba(1, 1, 1, 0.10) : "transparent"
            clip: true

            Behavior on width {
                NumberAnimation {
                    duration: Appearance.animationCurves.expressiveDefaultSpatialDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.animationCurves.expressiveDefaultSpatial
                }
            }
            Behavior on color { ColorAnimation { duration: 180 } }
            Behavior on border.color { ColorAnimation { duration: 180 } }
            Behavior on height {
                NumberAnimation {
                    duration: Appearance.animationCurves.expressiveFastSpatialDuration
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.animationCurves.expressiveFastSpatial
                }
            }
            Behavior on radius { NumberAnimation { duration: 200 } }

            RowLayout {
                id: pill
                anchors.top: root.flip ? undefined : parent.top
                anchors.bottom: root.flip ? parent.bottom : undefined
                anchors.left: parent.left
                anchors.right: parent.right
                height: root.pillH
                anchors.leftMargin: 12
                anchors.rightMargin: 5
                spacing: 8
                opacity: win.shown ? 1 : 0
                Behavior on opacity { NumberAnimation { duration: 160 } }

                MaterialSymbol {
                    text: "search"
                    iconSize: 20
                    color: Appearance.colors.colPrimary
                }

                TextInput {
                    id: field
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    verticalAlignment: TextInput.AlignVCenter
                    clip: true
                    font.family: Appearance.font.family.main
                    font.pixelSize: Appearance.font.pixelSize.normal
                    color: Appearance.colors.colOnLayer1
                    selectionColor: Appearance.colors.colSecondaryContainer
                    selectedTextColor: Appearance.m3colors.m3onSecondaryContainer
                    onTextChanged: root.query = text

                    Keys.onEscapePressed: {
                        if (text.length > 0) text = "";
                        else root.core.closeAll();
                    }
                    Keys.onDownPressed: root.selected = root.flip ? Math.max(0, root.selected - 1) : Math.min(root.results.length - 1, root.selected + 1)
                    Keys.onUpPressed: root.selected = root.flip ? Math.min(root.results.length - 1, root.selected + 1) : Math.max(0, root.selected - 1)
                    Keys.onReturnPressed: root.activate(root.results[root.selected])
                    Keys.onEnterPressed: root.activate(root.results[root.selected])

                    StyledText {
                        anchors.fill: parent
                        verticalAlignment: Text.AlignVCenter
                        visible: field.text.length === 0
                        text: Translation.tr("Search apps")
                        font.pixelSize: Appearance.font.pixelSize.normal
                        color: Appearance.m3colors.m3outline
                    }
                }

            }

            ListView {
                id: list
                anchors.top: root.flip ? parent.top : pill.bottom
                anchors.bottom: root.flip ? pill.top : parent.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 8
                anchors.topMargin: root.flip ? 8 : 0
                anchors.bottomMargin: root.flip ? 0 : 8
                verticalLayoutDirection: root.flip ? ListView.BottomToTop : ListView.TopToBottom
                clip: true
                spacing: 0
                model: root.results
                currentIndex: root.selected
                highlightMoveDuration: 120
                onCurrentIndexChanged: positionViewAtIndex(currentIndex, ListView.Contain)

                delegate: Rectangle {
                    id: row
                    required property var modelData
                    required property int index
                    readonly property bool sel: index === root.selected
                    readonly property var app: modelData.app
                    readonly property string iconSrc: !app ? "" : (app.icon && app.icon.charAt(0) === "/" ? "file://" + app.icon : Quickshell.iconPath(app.icon, "application-x-executable"))

                    width: list.width
                    height: root.rowH
                    radius: 20
                    color: sel ? Qt.alpha(Appearance.colors.colPrimaryContainer, 0.75) : "transparent"
                    Behavior on color { ColorAnimation { duration: 110 } }

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 10
                        anchors.rightMargin: 14
                        spacing: 12

                        Rectangle {
                            implicitWidth: 38
                            implicitHeight: 38
                            radius: row.sel ? 12 : 19
                            color: row.app ? "transparent" : Appearance.colors.colSecondaryContainer
                            Behavior on radius { NumberAnimation { duration: 160; easing.type: Easing.OutBack } }
                            Image {
                                visible: row.app !== undefined
                                anchors.centerIn: parent
                                width: 34
                                height: 34
                                sourceSize: Qt.size(68, 68)
                                source: row.iconSrc
                                fillMode: Image.PreserveAspectFit
                                asynchronous: true
                            }
                            MaterialSymbol {
                                visible: !row.app
                                anchors.centerIn: parent
                                text: row.modelData.icon ?? "search"
                                iconSize: 22
                                fill: 1
                                color: Appearance.colors.colOnSecondaryContainer
                            }
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0
                            StyledText {
                                Layout.fillWidth: true
                                text: row.modelData.title
                                elide: Text.ElideRight
                                font.pixelSize: row.modelData.kind === "calc" ? Appearance.font.pixelSize.larger : Appearance.font.pixelSize.normal
                                font.weight: row.modelData.kind === "calc" ? Font.DemiBold : Font.Normal
                                color: Appearance.colors.colOnLayer1
                            }
                            StyledText {
                                Layout.fillWidth: true
                                visible: text.length > 0
                                text: row.modelData.sub ?? ""
                                elide: Text.ElideMiddle
                                font.pixelSize: Appearance.font.pixelSize.smaller
                                color: Appearance.colors.colSubtext
                            }
                        }

                        Rectangle {
                            visible: row.sel
                            implicitWidth: hint.implicitWidth + 16
                            implicitHeight: 24
                            radius: 12
                            color: Appearance.colors.colPrimary
                            StyledText {
                                id: hint
                                anchors.centerIn: parent
                                text: row.modelData.kind === "calc" ? Translation.tr("copy ↵") : "↵"
                                font.pixelSize: Appearance.font.pixelSize.smaller
                                font.weight: Font.Bold
                                color: Appearance.colors.colOnPrimary
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: root.selected = row.index
                        onClicked: root.activate(row.modelData)
                    }
                }
            }
        }
    }
}
