import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.UPower
import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.common.functions

Item { // Bar content region
    id: root

    property var screen: root.QsWindow.window?.screen
    property var brightnessMonitor: Brightness.getMonitorForScreen(screen)
    Loader {
        active: Config.options.bar.showBackground && Config.options.bar.cornerStyle === 1 && Config.options.bar.floatStyleShadow
        anchors.fill: barBackground
        sourceComponent: StyledRectangularShadow {
            anchors.fill: undefined // The loader's anchors act on this, and this should not have any anchor
            target: barBackground
        }
    }
    Rectangle {
        id: barBackground
        anchors {
            fill: parent
            margins: Config.options.bar.cornerStyle === 1 ? (Appearance.sizes.hyprlandGapsOut) : 0 // idk why but +1 is needed
        }
        color: Config.options.bar.showBackground ? Appearance.colors.colLayer0 : "transparent"
        radius: Config.options.bar.cornerStyle === 1 ? Appearance.rounding.windowRounding : 0
        border.width: Config.options.bar.cornerStyle === 1 ? 1 : 0
        border.color: Appearance.colors.colLayer0Border
    }

    readonly property real sideMargin: (Config.options.bar.cornerStyle === 1 ? Appearance.sizes.hyprlandGapsOut : 0) + 8 + Appearance.rounding.screenRounding

    FocusedScrollMouseArea { // Left half | scroll to change brightness
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: centerSection.left
        }
        onScrollDown: Brightness.decreaseBrightness()
        onScrollUp: Brightness.increaseBrightness()
        onMovedAway: GlobalStates.osdBrightnessOpen = false
    }

    FocusedScrollMouseArea { // Right half | scroll to change volume
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: centerSection.right
            right: parent.right
        }
        onScrollDown: Audio.decrementVolume()
        onScrollUp: Audio.incrementVolume()
        onMovedAway: GlobalStates.osdVolumeOpen = false
    }

    BarSection {
        id: leftSection
        anchors {
            left: parent.left
            leftMargin: root.sideMargin
            verticalCenter: parent.verticalCenter
        }
        widgets: Config.options.bar.layout.left
    }

    BarSection {
        id: centerSection
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }
        widgets: Config.options.bar.layout.center
    }

    BarSection {
        id: rightSection
        anchors {
            right: parent.right
            rightMargin: root.sideMargin
            verticalCenter: parent.verticalCenter
        }
        widgets: Config.options.bar.layout.right
    }
}
