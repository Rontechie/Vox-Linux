import QtQuick
import Quickshell
import Qt5Compat.GraphicalEffects
import qs.modules.common
import qs.modules.common.widgets

Item {
    id: root
    property real size: 44
    property real ringWidth: 0
    property color ringColor: "#e6ffffff"
    readonly property bool ready: img.status === Image.Ready

    function toUrl(p) { return p.indexOf("file://") === 0 ? p : "file://" + p }
    readonly property string home: Quickshell.env("HOME")
    readonly property var candidates: {
        const c = [];
        const custom = Config.options.profile?.avatarPath ?? "";
        if (custom.length > 0) c.push(toUrl(custom));
        c.push("file://" + home + "/.face");
        c.push("file://" + home + "/.face.icon");
        c.push(toUrl(Directories.userAvatarPathAccountsService));
        return c;
    }
    property int idx: 0
    onCandidatesChanged: idx = 0

    implicitWidth: size
    implicitHeight: size

    Rectangle {
        anchors.fill: parent
        radius: width / 2
        color: Appearance.colors.colSecondaryContainer
        border.width: root.ringWidth
        border.color: root.ringColor
        MaterialSymbol {
            anchors.centerIn: parent
            visible: !root.ready
            text: "person"
            fill: 1
            iconSize: root.size * 0.58
            color: Appearance.m3colors.m3onSecondaryContainer
        }
    }
    Rectangle {
        id: mask
        anchors.fill: parent
        anchors.margins: root.ringWidth
        radius: width / 2
        visible: false
    }
    Image {
        id: img
        anchors.fill: parent
        anchors.margins: root.ringWidth
        source: root.idx < root.candidates.length ? root.candidates[root.idx] : ""
        sourceSize: Qt.size(root.size * 2, root.size * 2)
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
        visible: status === Image.Ready
        layer.enabled: true
        layer.effect: OpacityMask { maskSource: mask }
        onStatusChanged: if (status === Image.Error && root.idx < root.candidates.length) root.idx++
    }
}
