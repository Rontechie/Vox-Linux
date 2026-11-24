import QtQuick
import qs.services
import qs.modules.common

Item {
    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    Text {
        id: label
        readonly property bool muted: Audio.sink?.audio?.muted ?? false
        readonly property string icon: String.fromCodePoint(muted ? 0xF075F : 0xF057E)
        text: icon + " " + Math.round(Audio.value * 100) + "%"
        color: muted ? Theme.dim : Theme.fg
        font.family: Theme.mono
        font.pixelSize: Theme.fontSize
    }

    MouseArea {
        anchors.fill: parent
        onClicked: Audio.toggleMute()
        onWheel: wheel => wheel.angleDelta.y > 0 ? Audio.incrementVolume() : Audio.decrementVolume()
    }
}
