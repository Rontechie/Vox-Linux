import QtQuick
import Quickshell
import Quickshell.Bluetooth
import qs.modules.nexus.compat

QtObject {
    property ShellScreen screen
    property bool isWindow
    property bool animatingContainer
    property int currentPageIdx
    property list<int> subPageIdxStack
    property bool searchOpen

    property string selectedWallpaperCategory
    property BluetoothDevice selectedBtDevice
    property DesktopEntry selectedApp
    property int editingVpnIndex: -1
    property string selectedNetworkSsid
    property string selectedEthernetInterface
    property bool networkDetailsFromSaved

    signal close
    signal pickFile(tag: string, title: string)
    signal filePicked(tag: string, path: string)
    signal subPageOpened(idx: int)
    signal subPageClosed

    function openSubPage(idx: int): void {
        subPageIdxStack.push(idx);
        subPageOpened(idx);
    }

    function closeSubPage(): void {
        subPageClosed();
        subPageIdxStack.pop();
    }

    onCurrentPageIdxChanged: subPageIdxStack.length = 0

    Component.onCompleted: {
        const want = Quickshell.env("HYDRO_NEXUS_PAGE");
        if (!want)
            return;
        const idx = PageRegistry.pages.findIndex(p => p.label === Tr.tr(want));
        if (idx >= 0)
            currentPageIdx = idx;
    }
}
