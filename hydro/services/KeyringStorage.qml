pragma Singleton
pragma ComponentBehavior: Bound

import qs
import qs.modules.common
import qs.modules.common.functions
import Quickshell;
import Quickshell.Io;
import QtQuick;

Singleton {
    id: root

    signal dataChanged()

    property bool loaded: false
    property var keyringData: ({})
    
    property var properties: {
        "application": "hydro",
        "explanation": Translation.tr("For securely storing private app data"),
    }
    property var propertiesAsArgs: Object.keys(root.properties).reduce(
        function(arr, key) {
            return arr.concat([key, root.properties[key]]);
        }, []
    )
    property string keyringLabel: Translation.tr("%1 Safe Storage").arg("hydro")

    function setNestedField(path, value) {
        if (!root.keyringData) root.keyringData = {};
        let keys = path;
        let obj = root.keyringData;
        let parents = [obj];

        for (let i = 0; i < keys.length - 1; ++i) {
            if (!obj[keys[i]] || typeof obj[keys[i]] !== "object") {
                obj[keys[i]] = {};
            }
            obj = obj[keys[i]];
            parents.push(obj);
        }

        obj[keys[keys.length - 1]] = value;

        for (let i = keys.length - 2; i >= 0; --i) {
            let parent = parents[i];
            let key = keys[i];
            parent[key] = Object.assign({}, parent[key]);
        }

        root.keyringData = Object.assign({}, root.keyringData);

        saveKeyringData();
    }

    function fetchKeyringData() {
        getData.running = true;
    }

    function saveKeyringData() {
        saveData.stdinEnabled = true;
        saveData.running = true;
    }

    Process {
        id: saveData
        command: [
            "secret-tool", "store", "--label=" + keyringLabel,
            ...propertiesAsArgs,
        ]
        onRunningChanged: {
            if (saveData.running) {
                saveData.write(JSON.stringify(root.keyringData));
                root.dataChanged()
                stdinEnabled = false // End input stream
            }
        }
    }

    Process {
        id: getData
        command: [ // We need to use echo for a newline so splitparser does parse
            "bash", "-c", `${Directories.scriptPath}/keyring/try_lookup.sh 2> /dev/null`,
        ]
        stdout: StdioCollector {
            id: keyringDataOutputCollector
            onStreamFinished: {
                const data = keyringDataOutputCollector.text;
                if (data.length === 0 || !data.startsWith("{")) return;
                try {
                    root.keyringData = JSON.parse(data);
                } catch (e) {
                    console.error("[KeyringStorage] Failed to get keyring data, reinitializing.");
                    root.keyringData = {};
                    saveKeyringData()
                }
            }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 1) {
                console.error("[KeyringStorage] Entry not found, initializing.");
                root.keyringData = {};
                saveKeyringData()
            }
            if (exitCode !== 2) {
                root.loaded = true;
            }
        }
    }
    
}
