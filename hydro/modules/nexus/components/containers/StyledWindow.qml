import Quickshell
import Quickshell.Wayland
import qs.modules.nexus.compat

PanelWindow {
    required property string name

    WlrLayershell.namespace: `caelestia-${name}`
    color: "transparent"

    Tokens.screen: screen.name
}
