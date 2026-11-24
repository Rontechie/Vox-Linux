import QtQuick
import qs.modules.nexus.services

Image {
    source: Wallpapers.current ? (Wallpapers.current.startsWith("/") ? `file://${Wallpapers.current}` : Wallpapers.current) : ""
    fillMode: Image.PreserveAspectCrop
    asynchronous: true
    cache: false
    sourceSize.width: width
    sourceSize.height: height
}
