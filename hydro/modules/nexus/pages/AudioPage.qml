pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.modules.nexus.compat
import qs.modules.nexus.services
import qs.modules.nexus.utils
import qs.modules.nexus.common

PageBase {
    id: root

    title: Tr.tr("Audio")

    ColumnLayout {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        width: root.cappedWidth
        spacing: Tokens.spacing.extraSmall / 2

        SliderRow {
            first: true
            icon: Icons.getVolumeIcon(NxAudio.volume, NxAudio.muted)
            label: Tr.trCtx("Output", "audio output")
            valueLabel: Strings.percentOne(value)
            value: NxAudio.volume
            enabled: !NxAudio.muted
            onMoved: v => NxAudio.setVolume(v)
        }

        ToggleRow {
            text: Tr.trCtx("Muted", "audio output muted")
            checked: NxAudio.muted
            onToggled: NxAudio.setStreamMuted(NxAudio.sink, checked)
        }

        AudioDeviceList {
            nodes: NxAudio.sinks
            currentId: NxAudio.sink?.id ?? -1
            iconName: "speaker"
            placeholderIcon: "speaker"
            placeholderText: Tr.trCtx("No output devices", "no audio outputs")
            onSelected: node => NxAudio.setAudioSink(node)
        }

        SliderRow {
            Layout.topMargin: Tokens.spacing.large - parent.spacing
            first: true
            icon: Icons.getMicVolumeIcon(NxAudio.sourceVolume, NxAudio.sourceMuted)
            label: Tr.trCtx("Input", "audio input")
            valueLabel: Strings.percentOne(value)
            value: NxAudio.sourceVolume
            enabled: !NxAudio.sourceMuted
            onMoved: v => NxAudio.setSourceVolume(v)
        }

        ToggleRow {
            text: Tr.trCtx("Muted", "audio input muted")
            checked: NxAudio.sourceMuted
            onToggled: NxAudio.setStreamMuted(NxAudio.source, checked)
        }

        AudioDeviceList {
            nodes: NxAudio.sources
            currentId: NxAudio.source?.id ?? -1
            iconName: "mic"
            placeholderIcon: "mic_off"
            placeholderText: Tr.trCtx("No input devices", "no audio inputs")
            onSelected: node => NxAudio.setAudioSource(node)
        }

        NavRow {
            Layout.topMargin: Tokens.spacing.large - parent.spacing
            first: true
            last: true

            icon: "tune"
            text: Tr.tr("App volumes")
            subtext: NxAudio.streams.length === 0 ? Tr.tr("No apps playing audio") : Tr.trN("%n app playing audio", "%n apps playing audio", NxAudio.streams.length)
            onClicked: root.nState.openSubPage(1)
        }
    }
}
