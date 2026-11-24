import QtQuick
import QtQuick.Layouts
import qs.services
import qs.modules.common
import qs.modules.common.widgets
import qs.modules.settings.nexus

NxPage {
    id: page
    property string ssid: ""
    property string password: ""
    property bool hidden: false
    property bool busy: false
    property string error: ""

    function submit() {
        error = "";
        const name = ssid.trim();
        if (name.length === 0) { error = Translation.tr("Enter the network name"); return; }
        busy = true;
        NxNmcli.addNetwork(name, password, hidden, r => {
            page.busy = false;
            if (r && r.success) { Network.rescanWifi(); NxNav.pop(); }
            else page.error = (r && r.error && r.error.length > 0) ? r.error.trim() : Translation.tr("Could not add the network");
        });
    }

    NxHeader { text: Translation.tr("Network") }
    NxGroup {
        NxTextRow {
            icon: "wifi"; text: Translation.tr("Network name (SSID)")
            value: page.ssid
            onEdited: v => page.ssid = v
        }
        NwPasswordRow {
            text: Translation.tr("Password"); placeholder: Translation.tr("Leave empty for an open network")
            value: page.password
            onEdited: v => page.password = v
            onAccepted: page.submit()
        }
        NxToggleRow {
            icon: "visibility_off"; text: Translation.tr("Hidden network"); subtext: Translation.tr("The network does not broadcast its name")
            checked: page.hidden
            onToggled: v => page.hidden = v
        }
    }
    NxGroup {
        Layout.topMargin: 14
        NxInfoRow {
            visible: page.error.length > 0
            icon: "error"; text: page.error; value: ""
        }
        NxButtonRow {
            icon: "add"; text: Translation.tr("Add and connect")
            pill: Translation.tr("Add"); accent: true
            busy: page.busy; disabled: page.busy
            onClicked: { page.forceActiveFocus(); Qt.callLater(page.submit) }
        }
    }
}
