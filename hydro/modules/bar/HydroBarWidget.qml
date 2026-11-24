import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs
import qs.services
import qs.modules.common
import qs.modules.launcher
import qs.modules.common.widgets

Item {
    id: root
    required property string widgetId
    readonly property real ws: Config.options.bar.sizes.widgetScale
    readonly property real fs: Config.options.bar.sizes.fontScale

    implicitWidth: loader.implicitWidth
    implicitHeight: loader.implicitHeight

    Loader {
        id: loader
        anchors.centerIn: parent
        sourceComponent: {
            switch (root.widgetId) {
            case "logo": return logoC;
            case "windowTitle": return windowTitleC;
            case "workspaces": return workspacesC;
            case "tray": return trayC;
            case "status": return statusC;
            case "clock": return clockC;
            case "media": return Config.options.bar.mediaFace.replaceMedia ? mediaFaceC : classicC;
            case "mediaPlayer": return Config.options.bar.mediaFace.replaceMedia ? mediaFaceC : mediaPlayerC;
            case "mediaFace": return mediaFaceC;
            default: return classicC;
            }
        }
    }

    Component {
        id: classicC
        Item { // ids from the classic bar (media, resources, cpu, ram, network, battery, ...) in a capsule
            implicitWidth: pill.visible ? pill.implicitWidth : 0
            implicitHeight: pill.implicitHeight
            HydroPill {
                id: pill
                clickable: false
                hPadding: 10
                visible: inner.shown
                BarWidget {
                    id: inner
                    widgetId: root.widgetId
                    Layout.alignment: Qt.AlignVCenter
                }
            }
        }
    }

    Component {
        id: logoC
        Loader { // launcher.style "search": the button becomes a "Search apps" pill
            sourceComponent: Config.options.launcher.style === "search" ? searchPillC : logoButtonC
        }
    }

    Component {
        id: logoButtonC
        LauncherButton { // opens the launcher; icon and style are set in its settings
            ws: root.ws
        }
    }

    Component {
        id: searchPillC
        BarSearchPill {
            ws: root.ws
        }
    }

    Component {
        id: windowTitleC
        HydroPill { // focused window title
            clickable: false
            StyledText {
                Layout.maximumWidth: 300
                elide: Text.ElideRight
                animateChange: true
                font.pixelSize: Appearance.font.pixelSize.small * root.fs
                color: Appearance.colors.colOnLayer0
                text: ToplevelManager.activeToplevel?.activated ? (ToplevelManager.activeToplevel?.title ?? "") : "Desktop"
            }
        }
    }

    Component {
        id: workspacesC
        Loader {
            readonly property string t: Config.options.bar.workspaces.theme
            sourceComponent: t.indexOf("face-") === 0 ? faceWsC : plainWsC
            Component { id: plainWsC; HydroWorkspaces {} }
            Component { id: faceWsC; FaceWorkspaces { face: Config.options.bar.workspaces.theme.substring(5) } }
        }
    }

    Component {
        id: trayC
        Item { // tray in a capsule (hidden while there is nothing in the tray)
            implicitWidth: trayPill.visible ? trayPill.implicitWidth : 0
            implicitHeight: trayPill.implicitHeight
            HydroPill {
                id: trayPill
                clickable: false
                hPadding: 8
                visible: trayItems.implicitWidth > 0
                SysTray {
                    id: trayItems
                    Layout.alignment: Qt.AlignVCenter
                    invertSide: Config.options.bar.bottom
                }
            }
        }
    }

    Component {
        id: statusC
        HydroPill { // status cluster -> toggles the right sidebar
            id: statusPill
            spacing: 10
            emphasized: GlobalStates.sidebarRightOpen
            onClicked: GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen
            baseColor: GlobalStates.sidebarRightOpen ? Appearance.colors.colSecondaryContainer : "#1affffff"
            readonly property color fg: GlobalStates.sidebarRightOpen ? Appearance.colors.colOnSecondaryContainer : Appearance.colors.colOnLayer0

            MaterialSymbol {
                text: (Audio.sink?.audio?.muted ?? false) ? "volume_off" : "volume_up"
                iconSize: Appearance.font.pixelSize.larger * root.ws
                color: statusPill.fg
            }
            MaterialSymbol {
                text: Network.materialSymbol
                iconSize: Appearance.font.pixelSize.larger * root.ws
                color: statusPill.fg
            }
            MaterialSymbol {
                visible: BluetoothStatus.available
                text: BluetoothStatus.connected ? "bluetooth_connected" : BluetoothStatus.enabled ? "bluetooth" : "bluetooth_disabled"
                iconSize: Appearance.font.pixelSize.larger * root.ws
                color: statusPill.fg
            }
            MaterialSymbol { // notifications: bell with a dot or the unread count (Bar settings > Indicators)
                visible: Notifications.silent || Notifications.unread > 0
                text: Notifications.silent ? "notifications_paused" : "notifications"
                iconSize: Appearance.font.pixelSize.larger * root.ws
                color: statusPill.fg
                Rectangle {
                    visible: !Notifications.silent && Notifications.unread > 0 && !Config.options.bar.indicators.notifications.showUnreadCount
                    anchors { right: parent.right; top: parent.top; topMargin: 2 }
                    width: 7; height: 7; radius: 4
                    color: Appearance.colors.colPrimary
                }
                StyledText {
                    visible: !Notifications.silent && Notifications.unread > 0 && Config.options.bar.indicators.notifications.showUnreadCount
                    anchors { left: parent.right; leftMargin: 1; verticalCenter: parent.verticalCenter }
                    text: Notifications.unread > 99 ? "99+" : Notifications.unread
                    font.pixelSize: Appearance.font.pixelSize.smallest * root.fs
                    color: statusPill.fg
                }
            }
            HydroBattery {
                Layout.fillHeight: true
                visible: Battery.available
            }
        }
    }

    Component {
        id: mediaPlayerC
        HydroMediaPlayer {} // cover, title, time and previous / play-pause / next; hides while nothing plays
    }

    Component {
        id: mediaFaceC
        HydroMediaFace {} // Serpantinum media face: cover, scrolling title, time / author, controls
    }

    Component {
        id: clockC
        Loader {
            readonly property string st: Config.options.bar.clockStyle
            sourceComponent: st === "default" ? plainClockC : faceClockC
            Component { id: faceClockC; FaceClock { face: Config.options.bar.clockStyle } }
            Component { id: plainClockC; HydroPill { // clock: tonal pill (follows the capsule switch like the others)
            baseColor: Appearance.colors.colPrimaryContainer
            hoverColor: Appearance.colors.colPrimaryContainerHover
            onClicked: GlobalStates.sidebarRightOpen = !GlobalStates.sidebarRightOpen
            StyledText {
                text: DateTime.time
                font.pixelSize: Appearance.font.pixelSize.normal * root.fs
                font.weight: Font.Bold
                color: Appearance.colors.colOnPrimaryContainer
            }
            StyledText {
                text: DateTime.shortDate
                font.pixelSize: Appearance.font.pixelSize.smaller * root.fs
                color: Appearance.colors.colOnPrimaryContainer
                opacity: 0.7
            }
        } }
        }
    }
}
