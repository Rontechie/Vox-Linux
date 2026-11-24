pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import qs.modules.common

Singleton {
    id: root

    property bool wanted: false
    property bool valid: false
    property string city: ""
    property string desc: ""
    property string temp: ""
    property string feels: ""
    property int code: 113
    property int humidity: 0
    property int windKmh: 0
    property bool isDay: true
    property var days: [] // [{ date, desc, max, min }]

    readonly property bool useUSCS: Config.options.bar.weather.useUSCS
    readonly property string place: Config.options.bar.weather.city

    function minutesOf(s) { // "06:32 AM" -> minutes since midnight
        const m = /(\d+):(\d+)\s*(AM|PM)/i.exec(s || "");
        if (!m) return -1;
        let h = parseInt(m[1]) % 12;
        if (m[3].toUpperCase() === "PM") h += 12;
        return h * 60 + parseInt(m[2]);
    }

    function parse(text) {
        let j;
        try { j = JSON.parse(text); } catch (e) { return; }
        const cur = j?.current_condition?.[0];
        if (!cur) return;
        const us = root.useUSCS;
        root.city = j?.nearest_area?.[0]?.areaName?.[0]?.value ?? "";
        root.desc = cur?.weatherDesc?.[0]?.value ?? "";
        root.temp = (us ? cur.temp_F : cur.temp_C) + "°";
        root.feels = (us ? cur.FeelsLikeF : cur.FeelsLikeC) + "°";
        root.code = parseInt(cur.weatherCode) || 113;
        root.humidity = parseInt(cur.humidity) || 0;
        root.windKmh = parseInt(cur.windspeedKmph) || 0;
        const ast = j?.weather?.[0]?.astronomy?.[0];
        const now = new Date();
        const nowMin = now.getHours() * 60 + now.getMinutes();
        const rise = minutesOf(ast?.sunrise), set = minutesOf(ast?.sunset);
        root.isDay = (rise < 0 || set < 0) ? true : (nowMin >= rise && nowMin < set);
        root.days = (j?.weather ?? []).slice(0, 3).map(d => ({
            date: d.date,
            desc: d?.hourly?.[4]?.weatherDesc?.[0]?.value ?? "",
            max: us ? d.maxtempF : d.maxtempC,
            min: us ? d.mintempF : d.mintempC
        }));
        root.valid = true;
    }

    function refresh() {
        if (!root.wanted || fetcher.running) return;
        const place = encodeURIComponent((root.place || "").replace(/ /g, "+"));
        fetcher.command = ["curl", "-s", "--max-time", "20", "https://wttr.in/" + place + "?format=j1"];
        fetcher.running = true;
    }

    Process {
        id: fetcher
        stdout: StdioCollector {
            onStreamFinished: root.parse(text)
        }
    }
    Timer {
        interval: Math.max(5, Config.options.bar.weather.fetchInterval) * 60 * 1000
        running: root.wanted
        repeat: true
        triggeredOnStart: true
        onTriggered: root.refresh()
    }
    onWantedChanged: if (wanted) refresh()
    onPlaceChanged: refresh()
    onUseUSCSChanged: refresh()
}
