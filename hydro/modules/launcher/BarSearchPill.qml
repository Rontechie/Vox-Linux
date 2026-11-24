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
    readonly property bool open: GlobalStates.launcherOpen

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
    Timer { // layout shifts at startup / when widgets change
        interval: 1500
        running: root.visible
        repeat: true
        onTriggered: if (!GlobalStates.launcherOpen) root.report()
    }

    Rectangle {
        id: body
        anchors.fill: parent
        radius: height / 2
        color: root.open ? Appearance.colors.colPrimaryContainer
            : (ma.containsMouse ? Appearance.colors.colSecondaryContainerHover : Appearance.colors.colSecondaryContainer)
        Behavior on color { ColorAnimation { duration: 140 } }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 10 * root.ws
            anchors.rightMargin: 4 * root.ws
            spacing: 6 * root.ws

            MaterialSymbol {
                text: "search"
                iconSize: Appearance.font.pixelSize.larger * root.ws
                color: Appearance.colors.colPrimary
            }
            StyledText {
                Layout.fillWidth: true
                text: Translation.tr("Search apps")
                elide: Text.ElideRight
                font.pixelSize: Appearance.font.pixelSize.small * Config.options.bar.sizes.fontScale
                color: Appearance.m3colors.m3onSecondaryContainer
            }
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            z: -1
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: {
                root.report();
                SearchPillState.startMode = "apps";
                GlobalStates.launcherOpen = !GlobalStates.launcherOpen;
            }
        }
    }
}
