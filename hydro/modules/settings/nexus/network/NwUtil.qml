pragma Singleton
import QtQuick

QtObject {
    function wifiIcon(strength: int, secure: bool): string {
        const icon = strength > 75 ? "signal_wifi_4_bar" : strength > 50 ? "network_wifi_3_bar" : strength > 25 ? "network_wifi_2_bar" : "network_wifi_1_bar";
        return secure && strength > 0 ? icon + "_lock" : icon;
    }

    function band(freq: int): string {
        if (freq >= 4900 && freq <= 5900) return "5 GHz";
        if (freq >= 2400 && freq <= 2500) return "2.4 GHz";
        if (freq >= 5925) return "6 GHz";
        return "";
    }

    function isIpv4(v: string, withPrefix: bool): bool {
        const m = /^(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})(?:\/(\d{1,2}))?$/.exec(v.trim());
        if (!m) return false;
        for (let i = 1; i <= 4; i++) if (parseInt(m[i]) > 255) return false;
        if (withPrefix) return m[5] !== undefined && parseInt(m[5]) <= 32;
        return m[5] === undefined;
    }

    function validDnsList(v: string): bool {
        const items = v.split(",").map(s => s.trim()).filter(s => s.length > 0);
        return items.every(s => isIpv4(s, false));
    }
}
