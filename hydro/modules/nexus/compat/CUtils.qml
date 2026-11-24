pragma Singleton

import QtQuick
import Quickshell

Singleton {
    readonly property string version: "hydro"

    function clamp(v: real, lo: real, hi: real): real {
        return isNaN(v) ? lo : Math.max(lo, Math.min(hi, v));
    }

    function toLocalFile(path: url): string {
        return path.toString().replace(/^file:\/\//, "");
    }

    function dependency(value: var): void {
    }
}
