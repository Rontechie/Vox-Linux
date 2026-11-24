import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    id: page
    PwObjectTracker { objects: [...Audio.outputAppNodes, ...Audio.inputAppNodes] }

    function pct(v) { return Math.round(v * 100) + "%" }

    StyledText {
        Layout.fillWidth: true; Layout.leftMargin: 8; Layout.bottomMargin: 6
        wrapMode: Text.WordWrap
        text: Translation.tr("Adjust the volume of individual apps currently playing audio.")
        font.pixelSize: Appearance.font.pixelSize.small
        color: Appearance.m3colors.m3outline
    }

    NxHeader { text: Translation.tr("Playback") }
    NxGroup {
        Repeater {
            model: Audio.outputAppNodes
            NxSliderRow {
                required property var modelData
                icon: modelData.audio.muted ? "volume_off" : "volume_up"
                label: Audio.appNodeDisplayName(modelData)
                valueLabel: page.pct(modelData.audio.volume)
                value: modelData.audio.volume
                to: 1
                disabled: modelData.audio.muted
                onMoved: v => { modelData.audio.volume = v }
            }
        }
        NxInfoRow { visible: Audio.outputAppNodes.length === 0; icon: "music_off"; text: Translation.tr("No apps playing audio"); value: "" }
    }

    NxHeader { visible: Audio.inputAppNodes.length > 0; text: Translation.tr("Recording") }
    NxGroup {
        visible: Audio.inputAppNodes.length > 0
        Repeater {
            model: Audio.inputAppNodes
            NxSliderRow {
                required property var modelData
                icon: modelData.audio.muted ? "mic_off" : "mic"
                label: Audio.appNodeDisplayName(modelData)
                valueLabel: page.pct(modelData.audio.volume)
                value: modelData.audio.volume
                to: 1
                disabled: modelData.audio.muted
                onMoved: v => { modelData.audio.volume = v }
            }
        }
    }
}
