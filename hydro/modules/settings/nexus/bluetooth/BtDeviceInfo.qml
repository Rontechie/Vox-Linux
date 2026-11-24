import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    id: page
    readonly property string address: params?.address ?? ""
    readonly property var device: (Bluetooth.devices.values ?? []).find(d => d.address === address) ?? null
    readonly property bool connected: device?.state === BluetoothDeviceState.Connected
    readonly property bool loading: device?.state === BluetoothDeviceState.Connecting || device?.state === BluetoothDeviceState.Disconnecting

    onDeviceChanged: if (!device && address !== "") NxNav.pop() // forgotten or lost

    NxGroup {
        NxInfoRow {
            icon: "bluetooth"; text: Translation.tr("Status")
            value: !page.device ? "" : page.connected ? Translation.tr("Connected") : page.device.bonded ? Translation.tr("Paired") : Translation.tr("Not paired")
        }
        NxButtonRow {
            icon: page.connected ? "link_off" : "link"
            text: page.connected ? Translation.tr("Disconnect") : Translation.tr("Connect")
            busy: page.loading; disabled: page.loading
            onClicked: { if (page.device) page.device.connected = !page.connected }
        }
        NxButtonRow {
            icon: "delete"; text: Translation.tr("Forget this device")
            onClicked: { if (page.device) page.device.forget() }
        }
    }

    NxHeader { text: Translation.tr("Connection") }
    NxGroup {
        NxTextRow {
            icon: "edit"; text: Translation.tr("Name"); subtext: Translation.tr("Alias shown on this computer")
            value: page.device?.name ?? ""
            onEdited: v => { if (page.device && v.length > 0 && v !== page.device.name) page.device.name = v }
        }
        NxToggleRow {
            icon: "verified_user"; text: Translation.tr("Trusted"); subtext: Translation.tr("Allow this device to connect automatically")
            checked: page.device?.trusted ?? false
            onToggled: v => { if (page.device) page.device.trusted = v }
        }
        NxToggleRow {
            icon: "block"; text: Translation.tr("Blocked"); subtext: Translation.tr("Prevent this device from connecting")
            checked: page.device?.blocked ?? false
            onToggled: v => { if (page.device) page.device.blocked = v }
        }
        NxToggleRow {
            icon: "power_settings_new"; text: Translation.tr("Wake allowed"); subtext: Translation.tr("Allow this device to wake the system")
            checked: page.device?.wakeAllowed ?? false
            onToggled: v => { if (page.device) page.device.wakeAllowed = v }
        }
    }

    NxHeader { text: Translation.tr("Information") }
    NxGroup {
        NxRow {
            clickable: false
            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 14
                    NxLabelBlock { icon: "battery_full"; text: Translation.tr("Battery") }
                    StyledText {
                        text: page.device?.batteryAvailable ? Math.round(page.device.battery * 100) + "%" : Translation.tr("Unavailable")
                        color: Appearance.m3colors.m3onSurfaceVariant
                        font.pixelSize: Appearance.font.pixelSize.small
                    }
                }
                StyledProgressBar {
                    visible: page.device?.batteryAvailable ?? false
                    Layout.fillWidth: true
                    value: page.device?.battery ?? 0
                }
            }
        }
        NxInfoRow { icon: "tag"; text: Translation.tr("Address"); value: page.device?.address ?? "" }
    }
}
