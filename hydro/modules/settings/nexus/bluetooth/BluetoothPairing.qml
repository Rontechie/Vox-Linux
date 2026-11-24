import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    id: page
    readonly property var adapter: Bluetooth.defaultAdapter
    readonly property var found: (Bluetooth.devices.values ?? []).filter(d => !d.bonded && !d.paired)
        .sort((a, b) => (b.pairing - a.pairing) || (!a.deviceName - !b.deviceName) || a.name.localeCompare(b.name))
    property string pairingAddress: ""

    function setScan(on) { if (adapter && adapter.enabled) adapter.discovering = on }
    function icon(d) {
        const i = (d.icon ?? "");
        if (i.indexOf("headphone") >= 0 || i.indexOf("headset") >= 0) return "headphones";
        if (i.indexOf("mouse") >= 0) return "mouse";
        if (i.indexOf("keyboard") >= 0) return "keyboard";
        if (i.indexOf("phone") >= 0) return "smartphone";
        if (i.indexOf("audio") >= 0 || i.indexOf("speaker") >= 0) return "speaker";
        return "bluetooth";
    }

    Component.onCompleted: setScan(true)
    Component.onDestruction: setScan(false)

    Connections {
        target: page.adapter
        function onEnabledChanged() { if (page.adapter && !page.adapter.enabled) NxNav.pop() }
    }

    NxHeader { text: Translation.tr("Available devices") }
    NxGroup {
        NxInfoRow {
            visible: page.adapter?.discovering ?? false
            icon: "bluetooth_searching"; text: Translation.tr("Searching for devices…"); value: ""
        }
        Repeater {
            model: page.found
            NxButtonRow {
                id: dev
                required property var modelData
                icon: page.icon(modelData)
                text: modelData.name || Translation.tr("Unknown device")
                subtext: modelData.pairing ? Translation.tr("Pairing…") : modelData.address
                pill: modelData.pairing ? "" : Translation.tr("Pair")
                busy: modelData.pairing
                disabled: modelData.pairing
                onClicked: { page.pairingAddress = modelData.address; modelData.pair() }
            }
        }
    }

    Repeater {
        model: Bluetooth.devices.values
        Item {
            visible: false
            required property var modelData
            Connections {
                target: modelData
                function onPairedChanged() {
                    if (modelData.paired && modelData.address === page.pairingAddress) NxNav.pop()
                }
            }
        }
    }
}
