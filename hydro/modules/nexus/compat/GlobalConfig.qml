pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common
import qs.modules.common.functions

Singleton {
    id: root

    readonly property string filePath: FileUtils.trimFileProtocol(`${Directories.state}/user/nexus-settings.json`)

    readonly property alias general: adapter.general
    readonly property alias nexus: adapter.nexus
    readonly property alias services: adapter.services
    readonly property alias utilities: adapter.utilities
    readonly property alias paths: adapter.paths
    readonly property alias appearance: adapter.appearance
    readonly property alias bar: adapter.bar
    readonly property alias background: adapter.background

    readonly property QtObject vpnProviders: QtObject {
        readonly property var values: adapter.utilities.vpn.providers
        function at(i) { return adapter.utilities.vpn.providers[i]; }
        function insert(entry) { adapter.utilities.vpn.providers = adapter.utilities.vpn.providers.concat([entry]); }
        function remove(i) {
            const a = adapter.utilities.vpn.providers.slice();
            a.splice(i, 1);
            adapter.utilities.vpn.providers = a;
        }
    }

    property var screen: null

    FileView {
        id: file
        path: root.filePath
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeTimer.restart()
        onLoadFailed: error => {
            if (error == FileViewError.FileNotFound)
                writeAdapter();
        }

        JsonAdapter {
            id: adapter

            property JsonObject background: JsonObject {
                property bool wallpaperEnabled: true
            }
            property JsonObject general: JsonObject {
                property string logo: ""
            }
            property JsonObject nexus: JsonObject {
                property int wallpapersPerRow: 4
                property int maxNetworksShown: 5
                property int networkRescanInterval: 15000
            }
            property JsonObject services: JsonObject {
                property real audioIncrement: 0.1
                property real maxVolume: 1.0
            }
            property JsonObject appearance: JsonObject {
                property JsonObject transparency: JsonObject {
                    property bool enabled: false
                    property real base: 0.85
                    property real layers: 0.4
                }
            }
            property JsonObject paths: JsonObject {
                property string wallpaperDir: ""
            }
            property JsonObject bar: JsonObject {
                property JsonObject workspaces: JsonObject {
                    property list<var> windowIcons: []
                }
                property JsonObject tray: JsonObject {
                    property JsonObject iconSubs: JsonObject {
                        property list<var> values: []
                    }
                }
            }
            property JsonObject utilities: JsonObject {
                property JsonObject toasts: JsonObject {
                    property bool vpnChanged: true
                }
                property JsonObject vpn: JsonObject {
                    property bool enabled: false
                    property string selectedProvider: ""
                    property list<var> providers: []
                }
            }
        }
    }

    Timer {
        id: writeTimer
        interval: 100
        onTriggered: file.writeAdapter()
    }
}
