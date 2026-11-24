import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Mpris
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.desktopWidgets.ui

Rectangle {
    id: root
    property real collapsedW: 240
    property real expandedW: 440
    property bool expanded: false
    readonly property var player: MprisController.activePlayer
    readonly property bool playing: MprisController.isPlaying
    readonly property string title: player?.trackTitle ?? ""

    readonly property real collapsedH: 40
    readonly property real expandedH: 170
    width: expanded ? expandedW : collapsedW
    height: expanded ? expandedH : collapsedH
    radius: expanded ? 28 : collapsedH / 2
    color: Appearance.colors.colSecondaryContainer
    clip: true
    Behavior on width { NumberAnimation { duration: 320; easing.type: Easing.BezierSpline; easing.bezierCurve: Appearance.animationCurves.expressiveDefaultSpatial } }
    Behavior on height { NumberAnimation { duration: 320; easing.type: Easing.BezierSpline; easing.bezierCurve: Appearance.animationCurves.expressiveDefaultSpatial } }
    Behavior on radius { NumberAnimation { duration: 260 } }

    Timer { id: collapseTimer; interval: 280; onTriggered: root.expanded = false }
    HoverHandler {
        onHoveredChanged: {
            if (hovered) { collapseTimer.stop(); root.expanded = true; }
            else collapseTimer.restart();
        }
    }

    readonly property var bars: {
        const b = HwCava.values;
        const groups = [[0, 4], [4, 8], [8, 13], [13, 18]];
        const out = [];
        for (let g = 0; g < 4; g++) {
            let m = 0;
            for (let k = groups[g][0]; k < groups[g][1]; k++) m = Math.max(m, b[k] || 0);
            out.push(Math.min(1, m));
        }
        return out;
    }

    RowLayout {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.leftMargin: 18
        anchors.rightMargin: 18
        height: root.collapsedH
        spacing: 10
        opacity: root.expanded ? 0 : 1
        visible: opacity > 0.01
        Behavior on opacity { NumberAnimation { duration: root.expanded ? 100 : 240 } }

        Row {
            spacing: 2
            Layout.preferredHeight: 16
            Layout.alignment: Qt.AlignVCenter
            Repeater {
                model: 4
                Rectangle {
                    required property int index
                    width: 3
                    radius: 1.5
                    height: Math.max(3, 16 * (0.15 + 0.85 * (root.bars[index] || 0)))
                    anchors.verticalCenter: parent.verticalCenter
                    color: Appearance.colors.colPrimary
                    opacity: root.playing ? 1 : 0.5
                    Behavior on height { NumberAnimation { duration: 80 } }
                }
            }
        }
        StyledText {
            Layout.fillWidth: true
            text: root.title !== "" ? root.title : Translation.tr("No media playing")
            font.pixelSize: Appearance.font.pixelSize.small
            color: Appearance.colors.colOnSecondaryContainer
            elide: Text.ElideRight
        }
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 18
        spacing: 16
        opacity: root.expanded ? 1 : 0
        visible: opacity > 0.01
        Behavior on opacity { NumberAnimation { duration: root.expanded ? 260 : 80 } }

        Rectangle { // album art
            Layout.alignment: Qt.AlignVCenter
            implicitWidth: 112
            implicitHeight: 112
            radius: root.playing ? 56 : 24
            Behavior on radius { NumberAnimation { duration: 400; easing.type: Easing.OutCubic } }
            color: Appearance.colors.colLayer2
            clip: true
            Image {
                anchors.fill: parent
                source: root.player?.trackArtUrl ?? ""
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
                sourceSize: Qt.size(200, 200)
                visible: status === Image.Ready
            }
            MaterialSymbol {
                anchors.centerIn: parent
                visible: !(root.player?.trackArtUrl > "")
                text: "music_note"
                iconSize: 40
                color: Appearance.colors.colSubtext
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 2
            StyledText {
                Layout.fillWidth: true
                text: root.title !== "" ? root.title : Translation.tr("No media playing")
                font.pixelSize: Appearance.font.pixelSize.larger
                font.weight: Font.DemiBold
                color: Appearance.colors.colOnSecondaryContainer
                elide: Text.ElideRight
            }
            StyledText {
                Layout.fillWidth: true
                text: root.player?.trackArtist ?? ""
                font.pixelSize: Appearance.font.pixelSize.small
                color: Appearance.colors.colSubtext
                elide: Text.ElideRight
            }
            Item { Layout.fillHeight: true }
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 6
                radius: 3
                color: Qt.rgba(1, 1, 1, 0.14)
                Rectangle {
                    height: parent.height
                    radius: 3
                    color: Appearance.colors.colPrimary
                    width: parent.width * Math.min(1, Math.max(0, (root.player?.length ?? 0) > 0 ? (root.player.position / root.player.length) : 0))
                }
                Timer { // position is not pushed by MPRIS
                    interval: 1000; repeat: true
                    running: root.expanded && root.playing
                    onTriggered: if (root.player) root.player.positionChanged()
                }
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10
                Repeater {
                    model: [
                        { icon: "skip_previous", act: 0 },
                        { icon: root.playing ? "pause" : "play_arrow", act: 1 },
                        { icon: "skip_next", act: 2 }
                    ]
                    delegate: Rectangle {
                        id: cbtn
                        required property var modelData
                        implicitWidth: modelData.act === 1 ? 52 : 40
                        implicitHeight: 40
                        radius: cArea.pressed ? 10 : height / 2
                        Behavior on radius { NumberAnimation { duration: 140 } }
                        color: modelData.act === 1 ? Appearance.colors.colPrimary : Qt.rgba(1, 1, 1, 0.1)
                        MaterialSymbol {
                            anchors.centerIn: parent
                            text: cbtn.modelData.icon
                            fill: 1
                            iconSize: 24
                            color: cbtn.modelData.act === 1 ? Appearance.colors.colOnPrimary : Appearance.colors.colOnSecondaryContainer
                        }
                        MouseArea {
                            id: cArea
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                if (cbtn.modelData.act === 0) MprisController.previous();
                                else if (cbtn.modelData.act === 1) MprisController.togglePlaying();
                                else MprisController.next();
                            }
                        }
                    }
                }
            }
        }
    }
}
