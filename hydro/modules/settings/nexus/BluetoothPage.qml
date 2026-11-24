import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import qs.services
import qs.modules.common
import qs.modules.common.widgets

NxPage {
    id: page
    readonly property var adapter: Bluetooth.defaultAdapter

    function stateText(d) {
        if (d.connected) return Translation.tr("Connected") + (d.batteryAvailable ? " · " + Math.round(d.battery * 100) + "%" : "");
        if (d.paired) return Translation.tr("Paired");
        return Translation.tr("Available");
    }
    function icon(d) {
        const i = (d.icon ?? "");
        if (i.indexOf("headphone") >= 0 || i.indexOf("headset") >= 0) return "headphones";
        if (i.indexOf("mouse") >= 0) return "mouse";
        if (i.indexOf("keyboard") >= 0) return "keyboard";
        if (i.indexOf("phone") >= 0) return "smartphone";
        if (i.indexOf("audio") >= 0 || i.indexOf("speaker") >= 0) return "speaker";
        return "bluetooth";
    }

    NxGroup {
        NxToggleRow {
            icon: "bluetooth"; text: "Bluetooth"
            subtext: !BluetoothStatus.available ? Translation.tr("No adapter found") : BluetoothStatus.enabled ? Translation.tr("On") : Translation.tr("Off")
            disabled: !BluetoothStatus.available
            checked: BluetoothStatus.enabled
            onToggled: v => { if (page.adapter) page.adapter.enabled = v }
        }
        NxToggleRow {
            visible: BluetoothStatus.enabled
            icon: "radar"; text: Translation.tr("Look for devices"); subtext: Translation.tr("Make this computer discover nearby devices")
            checked: page.adapter?.discovering ?? false
            onToggled: v => { if (page.adapter) page.adapter.discovering = v }
        }
    }

    NxHeader { visible: BluetoothStatus.enabled && BluetoothStatus.connectedDevices.length > 0; text: Translation.tr("Connected") }
    NxGroup {
        visible: BluetoothStatus.enabled && BluetoothStatus.connectedDevices.length > 0
        Repeater {
            model: BluetoothStatus.connectedDevices
            NxButtonRow {
                required property var modelData
                icon: page.icon(modelData);
                text: modelData.name; subtext: page.stateText(modelData); pill: Translation.tr("Disconnect")
                onClicked: modelData.disconnect()
            }
        }
    }
    NxHeader { visible: BluetoothStatus.enabled && BluetoothStatus.pairedButNotConnectedDevices.length > 0; text: Translation.tr("Paired devices") }
    NxGroup {
        visible: BluetoothStatus.enabled && BluetoothStatus.pairedButNotConnectedDevices.length > 0
        Repeater {
            model: BluetoothStatus.pairedButNotConnectedDevices
            NxButtonRow {
                required property var modelData
                icon: page.icon(modelData)
                text: modelData.name; subtext: page.stateText(modelData); pill: Translation.tr("Connect")
                busy: modelData.state === BluetoothDeviceState.Connecting
                onClicked: modelData.connect()
            }
        }
    }
    NxHeader { visible: BluetoothStatus.enabled && BluetoothStatus.unpairedDevices.length > 0; text: Translation.tr("Available devices") }
    NxGroup {
        visible: BluetoothStatus.enabled && BluetoothStatus.unpairedDevices.length > 0
        Repeater {
            model: BluetoothStatus.unpairedDevices
            NxButtonRow {
                required property var modelData
                icon: page.icon(modelData)
                text: modelData.name; subtext: page.stateText(modelData); pill: Translation.tr("Pair")
                onClicked: modelData.pair()
            }
        }
    }
    NxGroup {
        Layout.topMargin: 14
        NxButtonRow {
            icon: "settings_bluetooth"; text: Translation.tr("Advanced Bluetooth settings")
            onClicked: Quickshell.execDetached(["bash", "-c", Config.options.apps.bluetooth])
        }
    }
}
