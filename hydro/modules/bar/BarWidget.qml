import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.bar.weather
import qs.modules.launcher
import QtQuick
import QtQuick.Layouts
import Quickshell

Loader {
    id: root
    required property string widgetId

    readonly property bool shown: {
        switch (widgetId) {
        case "battery": return Battery.available;
        case "weather": return true; // it is in the layout, so show it (the old enable flag defaulted to off and hid it)
        case "utilButtons": return Config.options.bar.verbose;
        case "media": return true;
        default: return sourceComponent !== null;
        }
    }

    sourceComponent: {
        switch (widgetId) {
        case "launcher": return launcherC;
        case "leftSidebar": return leftSidebarC;
        case "workspaces": return workspacesC;
        case "activeWindow": return activeWindowC;
        case "clock": return clockC;
        case "media": return mediaC;
        case "resources": return resourcesC;
        case "cpu": return cpuC;
        case "ram": return ramC;
        case "network": return networkC;
        case "tray": return trayC;
        case "status": return statusC;
        case "battery": return batteryC;
        case "notifications": return notificationsC;
        case "weather": return weatherC;
        case "utilButtons": return utilButtonsC;
        default: return null;
        }
    }

    Component {
        id: launcherBtnC
        RippleButton {
            implicitWidth: 30
            implicitHeight: 28
            buttonRadius: Appearance.rounding.full
            colBackground: "transparent"
            onClicked: GlobalStates.launcherOpen = !GlobalStates.launcherOpen
            MaterialSymbol {
                anchors.centerIn: parent
                fill: 1
                text: "apps"
                iconSize: Appearance.font.pixelSize.larger
                color: Appearance.colors.colOnLayer1
            }
        }
    }

    Component {
        id: launcherC
        Loader { // launcher.style "search": the button becomes a "Search apps" pill
            sourceComponent: Config.options.launcher.style === "search" ? searchPillC : launcherBtnC
        }
    }

    Component {
        id: searchPillC
        BarSearchPill {}
    }

    Component {
        id: leftSidebarC
        LeftSidebarButton {}
    }

    Component {
        id: workspacesC
        Workspaces {
            MouseArea { // Right-click toggles overview
                anchors.fill: parent
                acceptedButtons: Qt.RightButton
                onPressed: GlobalStates.overviewOpen = !GlobalStates.overviewOpen
            }
        }
    }

    Component {
        id: activeWindowC
        Item {
            implicitWidth: 220
            implicitHeight: Appearance.sizes.baseBarHeight
            ActiveWindow {
                anchors.fill: parent
            }
        }
    }

    Component {
        id: clockC
        MouseArea {
            implicitWidth: clock.implicitWidth
            implicitHeight: clock.implicitHeight
            onPressed: GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen
            ClockWidget {
                id: clock
                showDate: Config.options.bar.verbose
            }
        }
    }

    Component {
        id: mediaC
        Item {
            implicitWidth: 260
            implicitHeight: Appearance.sizes.baseBarHeight
            Media {
                anchors.fill: parent
            }
        }
    }

    Component {
        id: resourcesC
        Resources {
            alwaysShowAllResources: true
        }
    }

    Component {
        id: cpuC
        RowLayout {
            spacing: 4
            MaterialSymbol {
                text: "planner_review"
                iconSize: Appearance.font.pixelSize.larger
                color: ResourceUsage.cpuUsage * 100 >= Config.options.bar.resources.cpuWarningThreshold ? Appearance.colors.colError : Appearance.colors.colOnLayer1
            }
            StyledText {
                text: Math.round(ResourceUsage.cpuUsage * 100) + "%"
                color: Appearance.colors.colOnLayer1
            }
        }
    }

    Component {
        id: ramC
        RowLayout {
            spacing: 4
            MaterialSymbol {
                text: "memory"
                iconSize: Appearance.font.pixelSize.larger
                color: ResourceUsage.memoryUsedPercentage * 100 >= Config.options.bar.resources.memoryWarningThreshold ? Appearance.colors.colError : Appearance.colors.colOnLayer1
            }
            StyledText {
                text: Math.round(ResourceUsage.memoryUsedPercentage * 100) + "%"
                color: Appearance.colors.colOnLayer1
            }
        }
    }

    Component {
        id: networkC
        RowLayout {
            spacing: 4
            MaterialSymbol {
                text: Network.materialSymbol
                iconSize: Appearance.font.pixelSize.larger
                color: Appearance.colors.colOnLayer1
            }
            StyledText {
                Layout.maximumWidth: 110
                elide: Text.ElideRight
                text: Network.networkName
                visible: text.length > 0
                color: Appearance.colors.colOnLayer1
            }
        }
    }

    Component {
        id: trayC
        SysTray {
            invertSide: Config?.options.bar.bottom
        }
    }

    Component {
        id: statusC
        StatusIndicators {}
    }

    Component {
        id: batteryC
        BatteryIndicator {}
    }

    Component {
        id: notificationsC
        RippleButton {
            implicitWidth: notifRow.implicitWidth + 16
            implicitHeight: 28
            buttonRadius: Appearance.rounding.full
            colBackground: "transparent"
            onClicked: GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen
            RowLayout {
                id: notifRow
                anchors.centerIn: parent
                spacing: 4
                MaterialSymbol {
                    text: Notifications.silent ? "notifications_paused" : "notifications"
                    iconSize: Appearance.font.pixelSize.larger
                    color: Appearance.colors.colOnLayer1
                }
                StyledText {
                    visible: Notifications.unread > 0
                    text: Notifications.unread
                    color: Appearance.colors.colOnLayer1
                }
            }
        }
    }

    Component {
        id: weatherC
        WeatherBar {}
    }

    Component {
        id: utilButtonsC
        UtilButtons {}
    }
}
