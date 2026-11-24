import Quickshell.Wayland
import QtQuick
import qs.modules.common

Text {
    text: ToplevelManager.activeToplevel?.title ?? ""
    color: Theme.dim
    font.family: Theme.font
    font.pixelSize: Theme.fontSize
    elide: Text.ElideRight
    horizontalAlignment: Text.AlignHCenter
}
