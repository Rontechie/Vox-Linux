import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Layouts
import Quickshell

Item {
    id: root

    property real ws: 1
    readonly property var sc: Config.options.launcher.search
    readonly property var st: SearchPillState
    readonly property bool active: st.active
    readonly property real fs: Config.options.bar.sizes.fontScale

    implicitWidth: sc.pillWidth * ws
    implicitHeight: 30 * ws

    property bool logged: false
    function report() {
        const qw = QsWindow.window ?? Window.window;
        if (!qw || !qw.screen) return;
        const p = root.mapToItem(null, 0, 0);
        const bottom = Config.options.bar.bottom;
        const gx = p.x;
        const gy = bottom ? (qw.screen.height - qw.height + p.y) : p.y;
        SearchPillState.report(qw.screen.name, gx, gy, root.width, root.height, bottom);
        if (!logged) {
            logged = true;
            console.log("[SearchPill] anchored at " + Math.round(gx) + "," + Math.round(gy) + " (" + Math.round(root.width) + "x" + Math.round(root.height) + ") on " + qw.screen.name);
        }
    }
    Component.onCompleted: {
        Qt.callLater(root.report);
        reportSoon.start();
    }
    onWidthChanged: Qt.callLater(root.report)
    Timer { // the bar lays out a moment after startup
        id: reportSoon
        interval: 400
        onTriggered: root.report()
    }
    Timer { // layout shifts when widgets change
        interval: 1500
        running: root.visible
        repeat: true
        onTriggered: if (!root.active) root.report()
    }

    Rectangle {
        id: body
        anchors.fill: parent
        radius: height / 2
        color: root.active ? Appearance.colors.colPrimaryContainer
            : (ma.containsMouse ? Appearance.colors.colSecondaryContainerHover : ((Config.options.bar.capsules.enable && !Config.options.bar.islands.enable) ? (Appearance.capsuleCustom ? Appearance.capsuleFill : Appearance.colors.colSecondaryContainer) : "transparent"))
        border.width: root.active ? 2 : 0
        border.color: Appearance.colors.colPrimary
        Behavior on color { ColorAnimation { duration: 140 } }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10 * root.ws
            anchors.rightMargin: 4 * root.ws
            spacing: 6 * root.ws

            MaterialSymbol {
                text: root.active && root.st.mode === "files" ? "folder_open" : "search"
                iconSize: Appearance.font.pixelSize.larger * root.ws
                color: Appearance.colors.colPrimary
            }

            Item {
                id: area
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true

                StyledText {
                    anchors.verticalCenter: parent.verticalCenter
                    visible: !(root.active && root.st.query.length > 0)
                    text: root.active && root.st.mode === "files" ? Translation.tr("Search files") : Translation.tr("Search apps")
                    elide: Text.ElideRight
                    width: parent.width
                    font.pixelSize: Appearance.font.pixelSize.small * root.fs
                    color: Appearance.m3colors.m3onSecondaryContainer
                    opacity: root.active ? 0.55 : 1
                    leftPadding: root.active ? 2 : 0
                }

                Row {
                    id: typed
                    visible: root.active && root.st.query.length > 0
                    anchors.verticalCenter: parent.verticalCenter
                    x: Math.min(0, area.width - width)
                    StyledText {
                        text: root.st.query.slice(0, root.st.cursor)
                        font.pixelSize: Appearance.font.pixelSize.small * root.fs
                        color: Appearance.m3colors.m3onPrimaryContainer
                    }
                    Rectangle {
                        id: caretBar
                        width: 2
                        height: Appearance.font.pixelSize.small * root.fs + 4
                        anchors.verticalCenter: parent.verticalCenter
                        color: Appearance.colors.colPrimary
                        SequentialAnimation on opacity {
                            loops: Animation.Infinite
                            running: root.active
                            NumberAnimation { to: 0; duration: 500 }
                            NumberAnimation { to: 1; duration: 500 }
                        }
                    }
                    StyledText {
                        text: root.st.query.slice(root.st.cursor)
                        font.pixelSize: Appearance.font.pixelSize.small * root.fs
                        color: Appearance.m3colors.m3onPrimaryContainer
                    }
                }
                Rectangle {
                    visible: root.active && root.st.query.length === 0
                    x: 0
                    width: 2
                    height: Appearance.font.pixelSize.small * root.fs + 4
                    anchors.verticalCenter: parent.verticalCenter
                    color: Appearance.colors.colPrimary
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        running: root.active
                        NumberAnimation { to: 0; duration: 500 }
                        NumberAnimation { to: 1; duration: 500 }
                    }
                }
            }

            Rectangle {
                visible: root.sc.files
                implicitWidth: 22 * root.ws
                implicitHeight: 22 * root.ws
                radius: chipMa.pressed ? 6 : (root.active && root.st.mode === "files" ? 8 : width / 2)
                color: (root.active && root.st.mode === "files") || chipMa.containsMouse ? Appearance.colors.colPrimary : Qt.alpha(Appearance.colors.colPrimary, 0.16)
                Behavior on radius { NumberAnimation { duration: 160; easing.type: Easing.OutBack } }
                Behavior on color { ColorAnimation { duration: 120 } }
                MaterialSymbol {
                    anchors.centerIn: parent
                    text: "folder"
                    iconSize: 14 * root.ws
                    color: (root.active && root.st.mode === "files") || chipMa.containsMouse ? Appearance.colors.colOnPrimary : Appearance.colors.colPrimary
                }
                MouseArea {
                    id: chipMa
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        if (root.active) {
                            SearchPillState.mode = SearchPillState.mode === "files" ? "apps" : "files";
                        } else {
                            root.report();
                            SearchPillState.startMode = "files";
                            GlobalStates.launcherOpen = true;
                        }
                    }
                }
            }
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            z: -1
            hoverEnabled: true
            cursorShape: Qt.IBeamCursor
            onClicked: {
                if (Date.now() - SearchPillState.closedAt < 300) return; // that click just closed it
                root.report();
                SearchPillState.startMode = "apps";
                GlobalStates.launcherOpen = !GlobalStates.launcherOpen;
            }
        }
    }
}
