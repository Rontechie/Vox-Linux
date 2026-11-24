import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets

ColumnLayout {
    id: root
    spacing: 16

    LockCard { // weather
        Layout.fillWidth: true
        RowLayout {
            Layout.fillWidth: true
            spacing: 14
            MaterialSymbol {
                text: Icons.getWeatherIcon(Weather.data.wCode) ?? "cloud"
                iconSize: 54
                fill: 1
                color: Appearance.colors.colPrimary
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0
                StyledText {
                    text: Weather.data.temp
                    font.pixelSize: 34
                    font.weight: Font.DemiBold
                    color: Appearance.colors.colOnLayer1
                }
                StyledText {
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    text: Weather.data.city
                    color: Appearance.colors.colSubtext
                    font.pixelSize: Appearance.font.pixelSize.normal
                }
            }
        }
        RowLayout {
            Layout.fillWidth: true
            spacing: 8
            Repeater {
                model: [
                    { icon: "device_thermostat", text: Weather.data.tempFeelsLike },
                    { icon: "humidity_percentage", text: Weather.data.humidity },
                    { icon: "air", text: Weather.data.wind }
                ]
                delegate: Rectangle {
                    required property var modelData
                    Layout.fillWidth: true
                    implicitHeight: 34
                    radius: 17
                    color: Qt.rgba(1, 1, 1, 0.08)
                    Row {
                        anchors.centerIn: parent
                        spacing: 4
                        MaterialSymbol { text: parent.parent.modelData.icon; iconSize: 15; color: Appearance.colors.colSubtext; anchors.verticalCenter: parent.verticalCenter }
                        StyledText { text: parent.parent.modelData.text; font.pixelSize: Appearance.font.pixelSize.smaller; color: Appearance.colors.colOnLayer1; anchors.verticalCenter: parent.verticalCenter }
                    }
                }
            }
        }
    }

    LockCard { // media
        id: media
        Layout.fillWidth: true
        readonly property var player: MprisController.activePlayer
        visible: player !== null
        RowLayout {
            Layout.fillWidth: true
            spacing: 14
            Rectangle {
                implicitWidth: 64; implicitHeight: 64
                radius: 18
                color: Qt.rgba(1, 1, 1, 0.08)
                clip: true
                Image {
                    anchors.fill: parent
                    source: media.player?.trackArtUrl ?? ""
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    sourceSize: Qt.size(200, 200)
                    visible: status === Image.Ready
                }
                MaterialSymbol { anchors.centerIn: parent; text: "music_note"; iconSize: 28; color: Appearance.colors.colSubtext; visible: !(media.player?.trackArtUrl > "") }
            }
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2
                StyledText {
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    text: media.player?.trackTitle || Translation.tr("Unknown Title")
                    font.pixelSize: Appearance.font.pixelSize.larger
                    font.weight: Font.DemiBold
                    color: Appearance.colors.colOnLayer1
                }
                StyledText {
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    text: media.player?.trackArtist ?? ""
                    font.pixelSize: Appearance.font.pixelSize.small
                    color: Appearance.colors.colSubtext
                }
            }
        }
        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 12
            Repeater {
                model: [
                    { icon: "skip_previous", act: "prev" },
                    { icon: MprisController.isPlaying ? "pause" : "play_arrow", act: "toggle" },
                    { icon: "skip_next", act: "next" }
                ]
                delegate: Rectangle {
                    id: mb
                    required property var modelData
                    implicitWidth: modelData.act === "toggle" ? 52 : 40
                    implicitHeight: 40
                    radius: mbArea.pressed ? 12 : 20
                    Behavior on radius { NumberAnimation { duration: 140 } }
                    color: modelData.act === "toggle" ? Appearance.colors.colPrimary : Qt.rgba(1, 1, 1, 0.12)
                    MaterialSymbol {
                        anchors.centerIn: parent
                        text: mb.modelData.icon
                        iconSize: 22
                        fill: 1
                        color: mb.modelData.act === "toggle" ? Appearance.colors.colOnPrimary : Appearance.colors.colOnLayer1
                    }
                    MouseArea {
                        id: mbArea
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (mb.modelData.act === "prev") MprisController.previous();
                            else if (mb.modelData.act === "next") MprisController.next();
                            else MprisController.togglePlaying();
                        }
                    }
                }
            }
        }
    }
}
