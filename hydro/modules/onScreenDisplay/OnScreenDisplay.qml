import qs
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland

Scope {
    id: root
    property string protectionMessage: ""
    property var focusedScreen: Quickshell.screens.find(s => s.name === Hyprland.focusedMonitor?.name)

    property string currentIndicator: "volume"

    property bool btActive: false
    property bool btConnected: true
    property string btName: ""
    property string btIcon: "bluetooth"
    property bool btReady: false           // devices already connected at startup do not pop up
    property var btSnapshot: ({})          // address -> { name, icon } of the devices connected right now
    readonly property int btHoldMs: 2800   // the badge stays a little longer than a volume change

    function btInfo(d) {
        return {
            name: d.name || d.deviceName || d.address || Translation.tr("Bluetooth device"),
            icon: Icons.getBluetoothDeviceMaterialSymbol(d.icon || "")
        };
    }
    function showBluetooth(connected, info) {
        if (Config.options.osd.bluetooth === false)
            return;
        btConnected = connected;
        btName = info.name;
        btIcon = info.icon;
        btActive = true;
        protectionMessage = "";
        currentIndicator = "volume";       // the original OSD comes up too
        triggerOsd();
    }
    function checkBluetooth() {
        const now = {};
        for (const d of BluetoothStatus.connectedDevices)
            now[d.address] = btInfo(d);
        if (btReady) {
            for (const addr in now)
                if (!(addr in btSnapshot)) showBluetooth(true, now[addr]);
            for (const addr in btSnapshot)
                if (!(addr in now)) showBluetooth(false, btSnapshot[addr]);
        }
        btSnapshot = now;
    }
    Component.onCompleted: checkBluetooth()
    Timer {
        interval: 3000
        running: true
        onTriggered: root.btReady = true
    }
    Connections {
        target: BluetoothStatus
        function onConnectedDevicesChanged() {
            root.checkBluetooth();
        }
    }
    Connections {
        target: GlobalStates
        function onOsdVolumeOpenChanged() {
            if (!GlobalStates.osdVolumeOpen)
                root.btActive = false;
        }
    }
    property var indicators: [
        {
            id: "volume",
            sourceUrl: "indicators/VolumeIndicator.qml"
        },
        {
            id: "brightness",
            sourceUrl: "indicators/BrightnessIndicator.qml"
        },
        {
            id: "gamma",
            sourceUrl: "indicators/GammaIndicator.qml"
        },
    ]

    function triggerOsd() {
        GlobalStates.osdVolumeOpen = true;
        osdTimeout.restart();
    }

    Timer {
        id: osdTimeout
        interval: Math.max(Config.options.osd.timeout, root.btActive ? root.btHoldMs : 0)
        repeat: false
        running: false
        onTriggered: {
            GlobalStates.osdVolumeOpen = false;
            root.protectionMessage = "";
            root.btActive = false;
        }
    }

    Connections {
        target: Brightness
        function onBrightnessChanged() {
            root.protectionMessage = "";
            root.currentIndicator = "brightness";
            root.triggerOsd();
        }
    }

    Connections {
        target: Hyprsunset
        function onGammaChangeAttempt() {
            root.protectionMessage = "";
            root.currentIndicator = "gamma";
            root.triggerOsd();
        }
    }

    Connections {
        target: Audio.sink?.audio ?? null
        function onVolumeChanged() {
            if (!Audio.ready)
                return;
            root.currentIndicator = "volume";
            root.triggerOsd();
        }
        function onMutedChanged() {
            if (!Audio.ready)
                return;
            root.currentIndicator = "volume";
            root.triggerOsd();
        }
    }

    Connections {
        target: Audio
        function onSinkProtectionTriggered(reason) {
            root.protectionMessage = reason;
            root.currentIndicator = "volume";
            root.triggerOsd();
        }
    }

    Loader {
        id: osdLoader
        active: GlobalStates.osdVolumeOpen

        sourceComponent: PanelWindow {
            id: osdRoot
            color: "transparent"

            Connections {
                target: root
                function onFocusedScreenChanged() {
                    osdRoot.screen = root.focusedScreen;
                }
            }

            WlrLayershell.namespace: "quickshell:onScreenDisplay"
            WlrLayershell.layer: WlrLayer.Overlay
            anchors {
                top: !Config.options.bar.bottom
                bottom: Config.options.bar.bottom
            }
            mask: Region {
                item: osdValuesWrapper
                Region {
                    item: btBadgeLoader
                }
            }

            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            margins {
                top: Appearance.sizes.barHeight
                bottom: Appearance.sizes.barHeight
            }

            implicitWidth: columnLayout.implicitWidth
            implicitHeight: columnLayout.implicitHeight
            visible: osdLoader.active

            RowLayout {
                id: columnLayout
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 0

                Item {
                    id: osdValuesWrapper
                    Layout.alignment: Qt.AlignTop
                    implicitHeight: contentColumnLayout.implicitHeight
                    implicitWidth: contentColumnLayout.implicitWidth
                    clip: true

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: GlobalStates.osdVolumeOpen = false
                    }

                    Column {
                        id: contentColumnLayout
                        anchors {
                            top: parent.top
                            left: parent.left
                            right: parent.right
                        }
                        spacing: 0

                        Loader {
                            id: osdIndicatorLoader
                            source: root.indicators.find(i => i.id === root.currentIndicator)?.sourceUrl
                        }

                        Item {
                            id: protectionMessageWrapper
                            anchors.horizontalCenter: parent.horizontalCenter
                            implicitHeight: protectionMessageBackground.implicitHeight
                            implicitWidth: protectionMessageBackground.implicitWidth
                            opacity: root.protectionMessage !== "" ? 1 : 0

                            StyledRectangularShadow {
                                target: protectionMessageBackground
                            }
                            Rectangle {
                                id: protectionMessageBackground
                                anchors.centerIn: parent
                                color: Appearance.m3colors.m3error
                                property real padding: 10
                                implicitHeight: protectionMessageRowLayout.implicitHeight + padding * 2
                                implicitWidth: protectionMessageRowLayout.implicitWidth + padding * 2
                                radius: 6

                                RowLayout {
                                    id: protectionMessageRowLayout
                                    anchors.centerIn: parent
                                    MaterialSymbol {
                                        id: protectionMessageIcon
                                        text: "dangerous"
                                        iconSize: Appearance.font.pixelSize.hugeass
                                        color: Appearance.m3colors.m3onError
                                    }
                                    StyledText {
                                        id: protectionMessageTextWidget
                                        horizontalAlignment: Text.AlignHCenter
                                        color: Appearance.m3colors.m3onError
                                        wrapMode: Text.Wrap
                                        text: root.protectionMessage
                                    }
                                }
                            }
                        }
                    }
                }

                Loader {
                    id: btBadgeLoader
                    Layout.alignment: Qt.AlignTop
                    active: root.btActive
                    visible: active
                    sourceComponent: BluetoothBadge {
                        name: root.btName
                        icon: root.btIcon
                        connected: root.btConnected
                    }
                }
            }
        }
    }

    IpcHandler {
        target: "osdBluetooth"

        function show(state: string, name: string): void {
            root.showBluetooth(state !== "disconnected", {
                name: name !== "" ? name : "Test Headphones",
                icon: "headphones"
            });
        }
    }

    IpcHandler {
        target: "osdVolume"

        function trigger() {
            root.triggerOsd();
        }

        function hide() {
            GlobalStates.osdVolumeOpen = false;
        }

        function toggle() {
            GlobalStates.osdVolumeOpen = !GlobalStates.osdVolumeOpen;
        }
    }
    GlobalShortcut {
        name: "osdVolumeTrigger"
        description: "Triggers volume OSD on press"

        onPressed: {
            root.triggerOsd();
        }
    }
    GlobalShortcut {
        name: "osdVolumeHide"
        description: "Hides volume OSD on press"

        onPressed: {
            GlobalStates.osdVolumeOpen = false;
        }
    }
}
