import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    id: page
    property string type: "wireguard"
    property string file: ""
    property bool busy: false
    property string error: ""
    property string pendingDelete: ""
    Component.onCompleted: NxNmcli.refreshVpn(null)

    function submit() {
        error = "";
        if (file.trim().length === 0) { error = Translation.tr("Enter the path of the config file"); return; }
        busy = true;
        NxNmcli.vpnImport(type, file.trim(), r => {
            page.busy = false;
            if (r && r.success) NxNav.pop();
            else page.error = (r && r.error && r.error.length > 0) ? r.error.trim() : Translation.tr("Could not import the file");
        });
    }

    NxHeader { text: Translation.tr("Import profile") }
    NxGroup {
        NxSelectRow {
            icon: "vpn_lock"; text: Translation.tr("Type")
            model: [{ value: "wireguard", label: "WireGuard" }, { value: "openvpn", label: "OpenVPN" }]
            current: page.type
            onPicked: v => page.type = v
        }
        NxTextRow {
            wide: true
            icon: "description"; text: Translation.tr("Config file")
            placeholder: page.type === "wireguard" ? "~/wg0.conf" : "~/client.ovpn"
            value: page.file
            onEdited: v => page.file = v
        }
        NxInfoRow {
            visible: page.error.length > 0
            icon: "error"; text: page.error; value: ""
        }
        NxButtonRow {
            icon: "upload_file"; text: Translation.tr("Import")
            pill: Translation.tr("Import"); accent: true
            busy: page.busy; disabled: page.busy
            onClicked: { page.forceActiveFocus(); Qt.callLater(page.submit) }
        }
    }

    NxHeader { visible: NxNmcli.vpnProfiles.length > 0; text: Translation.tr("Existing profiles") }
    NxGroup {
        visible: NxNmcli.vpnProfiles.length > 0
        Repeater {
            model: NxNmcli.vpnProfiles
            delegate: NxButtonRow {
                required property var modelData
                readonly property bool confirming: page.pendingDelete === modelData.name
                icon: "vpn_key"; text: modelData.name
                subtext: confirming ? Translation.tr("Tap again to remove") : (modelData.type === "wireguard" ? "WireGuard" : "VPN")
                pill: confirming ? Translation.tr("Remove") : ""
                accent: confirming
                onClicked: {
                    if (confirming) { page.pendingDelete = ""; NxNmcli.vpnDelete(modelData.name, null); }
                    else page.pendingDelete = modelData.name;
                }
            }
        }
    }
}
