pragma Singleton
import QtQuick
import Quickshell

Singleton {
    property bool known: false
    property string screenName: ""
    property real x: 0
    property real y: 0
    property real w: 170
    property real h: 30
    property bool bottom: false
    property string startMode: "apps"

    function report(screen, px, py, pw, ph, atBottom) {
        screenName = screen;
        x = px; y = py; w = pw; h = ph;
        bottom = atBottom;
        known = true;
    }
}
