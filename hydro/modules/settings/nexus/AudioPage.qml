import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import qs.services
import qs.modules.common
import qs.modules.common.widgets

NxPage {
    id: page
    PwObjectTracker { objects: [...Audio.outputDevices, ...Audio.inputDevices, ...Audio.outputAppNodes, ...Audio.inputAppNodes] }

    function pct(v) { return Math.round(v * 100) + "%" }

    NxHeader { text: Translation.tr("Output") }
    NxGroup {
        NxSliderRow {
            icon: Audio.sink?.audio.muted ? "volume_off" : "volume_up"
            label: Translation.tr("Volume")
            valueLabel: page.pct(Audio.sink?.audio.volume ?? 0)
            value: Audio.sink?.audio.volume ?? 0
            to: Audio.hardMaxValue
            disabled: Audio.sink?.audio.muted ?? false
            onMoved: v => { if (Audio.sink) Audio.sink.audio.volume = v }
        }
        NxToggleRow {
            icon: "volume_mute"; text: Translation.tr("Muted")
            checked: Audio.sink?.audio.muted ?? false
            onToggled: v => { if (Audio.sink) Audio.sink.audio.muted = v }
        }
        Repeater {
            model: Audio.outputDevices
            NxButtonRow {
                required property var modelData
                icon: "speaker"
                text: Audio.friendlyDeviceName(modelData)
                pill: modelData === Audio.sink ? Translation.tr("In use") : ""
                accent: modelData === Audio.sink
                onClicked: Audio.setDefaultSink(modelData)
            }
        }
    }

    NxHeader { text: Translation.tr("Input") }
    NxGroup {
        NxSliderRow {
            icon: Audio.source?.audio.muted ? "mic_off" : "mic"
            label: Translation.tr("Volume")
            valueLabel: page.pct(Audio.source?.audio.volume ?? 0)
            value: Audio.source?.audio.volume ?? 0
            to: 1
            disabled: Audio.source?.audio.muted ?? false
            onMoved: v => { if (Audio.source) Audio.source.audio.volume = v }
        }
        NxToggleRow {
            icon: "mic_off"; text: Translation.tr("Muted")
            checked: Audio.source?.audio.muted ?? false
            onToggled: v => { if (Audio.source) Audio.source.audio.muted = v }
        }
        Repeater {
            model: Audio.inputDevices
            NxButtonRow {
                required property var modelData
                icon: "mic"
                text: Audio.friendlyDeviceName(modelData)
                pill: modelData === Audio.source ? Translation.tr("In use") : ""
                accent: modelData === Audio.source
                onClicked: Audio.setDefaultSource(modelData)
            }
        }
    }

    NxHeader { text: Translation.tr("App volumes") }
    NxGroup {
        Repeater {
            model: Audio.outputAppNodes
            NxSliderRow {
                required property var modelData
                icon: "tune"
                label: Audio.appNodeDisplayName(modelData)
                valueLabel: page.pct(modelData.audio.volume)
                value: modelData.audio.volume
                to: 1
                onMoved: v => { modelData.audio.volume = v }
            }
        }
        NxInfoRow { visible: Audio.outputAppNodes.length === 0; icon: "music_off"; text: Translation.tr("No apps playing audio"); value: "" }
    }
    NxGroup {
        Layout.topMargin: 14
        NxButtonRow {
            icon: "tune"; text: Translation.tr("Open volume mixer")
            onClicked: Quickshell.execDetached(["bash", "-c", Config.options.apps.volumeMixer])
        }
    }
}
