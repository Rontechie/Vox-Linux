import QtQuick
import Quickshell.Io

Item {
    id: root

    enum Status { Idle, Checking, UpToDate, Available, Updating, Done, Failed, Unsupported }

    property int status: SystemUpdater.Idle
    property bool autoCheck: true
    property bool supported: false
    property string missing: ""

    property var packages: []          // [{ name, from, to }]
    readonly property int count: packages.length
    property var logLines: []
    property string phase: ""
    property real progress: -1         // -1 = indeterminate
    property int current: 0
    property int total: 0
    property string error: ""
    property bool restartRecommended: false
    property var lastChecked: null     // Date

    readonly property bool busy: status === SystemUpdater.Checking || status === SystemUpdater.Updating

    signal updated

    visible: false

    Process {
        id: probe
        running: true
        command: ["sh", "-c", "for c in pacman checkupdates pkexec; do command -v $c >/dev/null 2>&1 || { echo $c; exit 1; }; done"]
        stdout: StdioCollector {
            onStreamFinished: root.missing = text.trim()
        }
        onExited: code => {
            root.supported = code === 0;
            if (!root.supported)
                root.status = SystemUpdater.Unsupported;
            else if (root.autoCheck)
                root.check();
        }
    }

    property string _checkOut: ""
    property int _checkCode: -1
    property bool _checkOutDone: false

    function check(): void {
        if (!supported || busy)
            return;
        status = SystemUpdater.Checking;
        error = "";
        _checkOut = "";
        _checkCode = -1;
        _checkOutDone = false;
        checkProc.running = true;
    }

    function _finishCheck(): void {
        if (!_checkOutDone || _checkCode < 0)
            return;
        const code = _checkCode;
        _checkCode = -1;
        lastChecked = new Date();
        if (code === 2) { // checkupdates: 2 = nothing to update
            packages = [];
            status = SystemUpdater.UpToDate;
        } else if (code === 0) {
            const list = [];
            for (const line of _checkOut.split("\n")) {
                const m = line.match(/^(\S+)\s+(\S+)\s+->\s+(\S+)/);
                if (m)
                    list.push({ "name": m[1], "from": m[2], "to": m[3] });
            }
            packages = list;
            status = list.length > 0 ? SystemUpdater.Available : SystemUpdater.UpToDate;
        } else {
            status = SystemUpdater.Failed;
            error = "Couldn't check for updates (checkupdates exited with code " + code + ").";
        }
    }

    Process {
        id: checkProc
        command: ["checkupdates"]
        stdout: StdioCollector {
            onStreamFinished: {
                root._checkOut = text;
                root._checkOutDone = true;
                root._finishCheck();
            }
        }
        onExited: code => {
            root._checkCode = code;
            root._finishCheck();
        }
    }

    function update(): void {
        if (!supported || busy)
            return;
        status = SystemUpdater.Updating;
        error = "";
        logLines = [];
        phase = "Waiting for authentication…";
        progress = -1;
        current = 0;
        total = 0;
        restartRecommended = false;
        updateProc.running = true;
    }

    function _onLine(data): void {
        const line = String(data).split("\r").pop().trim();
        if (!line)
            return;
        const l = logLines.slice(-199);
        l.push(line);
        logLines = l;

        let m;
        if ((m = line.match(/^\(\s*(\d+)\/(\d+)\)\s+(upgrading|installing|reinstalling|downgrading)\s+(\S+)/))) {
            current = parseInt(m[1]);
            total = parseInt(m[2]);
            progress = total > 0 ? current / total : -1;
            phase = m[3].charAt(0).toUpperCase() + m[3].slice(1) + " " + m[4];
        } else if ((m = line.match(/^\(\s*\d+\/\d+\)\s+(.*)$/))) {
            phase = m[1].charAt(0).toUpperCase() + m[1].slice(1);
        } else if (/Synchronizing package databases/.test(line)) {
            phase = "Syncing databases";
        } else if (/Starting full system upgrade/.test(line)) {
            phase = "Preparing the upgrade";
        } else if (/Retrieving packages/.test(line)) {
            phase = "Downloading packages";
        } else if (/post-transaction hooks/.test(line)) {
            phase = "Running hooks";
        } else if (/there is nothing to do/.test(line)) {
            phase = "Nothing to do";
        }
    }

    function _onUpdateExit(code): void {
        if (code === 0) {
            restartRecommended = packages.some(p => /^(linux(-lts|-zen|-hardened|-rt)?|nvidia[\w-]*)$/.test(p.name));
            packages = [];
            progress = 1;
            phase = "";
            lastChecked = new Date();
            status = SystemUpdater.Done;
            updated();
        } else {
            status = SystemUpdater.Failed;
            const noAgent = logLines.some(l => /no authentication agent|error getting authority/i.test(l));
            if (noAgent)
                error = "No polkit agent is running, so there was nothing to ask for your password. Start Hydro's main shell (it provides one).";
            else if (code === 126 || code === 127)
                error = "Authentication was cancelled or isn't allowed.";
            else
                error = "pacman exited with code " + code + (logLines.length ? ": " + logLines[logLines.length - 1] : ".");
        }
    }

    Process {
        id: updateProc
        command: ["pkexec", "pacman", "-Syu", "--noconfirm", "--noprogressbar"]
        stdout: SplitParser {
            onRead: data => root._onLine(data)
        }
        stderr: SplitParser {
            onRead: data => root._onLine(data)
        }
        onExited: code => root._onUpdateExit(code)
    }
}
