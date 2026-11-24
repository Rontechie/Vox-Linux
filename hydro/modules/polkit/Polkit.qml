import qs.modules.common
import qs.modules.common.widgets
import QtQuick

FullscreenPolkitWindow {
    contentComponent: Config.options.polkit.style === "classic" ? classicStyle : hydroStyle

    property Component hydroStyle: Component { PolkitContent {} }
    property Component classicStyle: Component { PolkitContentClassic {} }
}
