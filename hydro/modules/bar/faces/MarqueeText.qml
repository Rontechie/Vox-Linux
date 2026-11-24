import QtQuick

Item {
    id: root

    property string text: ""
    property color color: "white"
    property string fontFamily: ""
    property real fontPixelSize: 12
    property int fontWeight: Font.Normal
    property real marqueeSpacing: 40
    property real speed: 30      // px per second
    property bool active: true   // only scroll while true (e.g. while playing)

    readonly property real textWidth: metrics.advanceWidth
    readonly property bool scrolling: active && textWidth > width && width > 0
    property real offset: 0

    implicitHeight: label.implicitHeight
    clip: true

    TextMetrics {
        id: metrics
        text: root.text
        font.family: root.fontFamily
        font.pixelSize: root.fontPixelSize
        font.weight: root.fontWeight
    }

    Text {
        id: label
        x: -root.offset
        width: root.scrolling ? root.textWidth : root.width
        text: root.text
        color: root.color
        elide: root.scrolling ? Text.ElideNone : Text.ElideRight
        font.family: root.fontFamily
        font.pixelSize: root.fontPixelSize
        font.weight: root.fontWeight
    }
    Text { // second copy trails the first so the loop is seamless
        visible: root.scrolling
        x: root.textWidth + root.marqueeSpacing - root.offset
        text: root.text
        color: root.color
        font.family: root.fontFamily
        font.pixelSize: root.fontPixelSize
        font.weight: root.fontWeight
    }

    NumberAnimation on offset {
        running: root.scrolling
        from: 0
        to: root.textWidth + root.marqueeSpacing
        duration: Math.max(1, (root.textWidth + root.marqueeSpacing) / Math.max(1, root.speed) * 1000)
        loops: Animation.Infinite
    }
    onScrollingChanged: if (!scrolling) offset = 0
    onTextChanged: offset = 0
}
