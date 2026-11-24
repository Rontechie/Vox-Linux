import QtQuick

Image {
    property bool playing: false
    readonly property bool ready: status === Image.Ready

    fillMode: Image.PreserveAspectCrop
    asynchronous: true
    cache: true
    sourceSize.width: Math.max(1, Math.round(width))
    sourceSize.height: Math.max(1, Math.round(height))
}
