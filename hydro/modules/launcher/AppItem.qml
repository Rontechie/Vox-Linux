import QtQuick
import qs.modules.common
import qs.modules.common.widgets
import Quickshell
import Quickshell.Widgets

Item {
    id: it
    property var pal
    property var app
    property int iconPx: 48
    property bool showLabel: true
    property string shapeName: "square"
    property bool hoverMorph: true
    property bool editMode: false
    property bool interactive: true
    property bool pinned: false
    property bool selected: false
    signal launch()
    signal pinToggle()

    readonly property bool hovered: ma.containsMouse && interactive
    readonly property string papirusDir: "/usr/share/icons/Papirus/64x64/apps/"
    readonly property string papirusSrc: (app && app.icon) ? (app.icon.charAt(0) === "/" ? "file://" + app.icon : "file://" + papirusDir + app.icon + ".svg") : src
    readonly property string src: (app && app.icon) ? (app.icon.charAt(0) === "/" ? "file://" + app.icon : Quickshell.iconPath(app.icon, "application-x-executable")) : Quickshell.iconPath("application-x-executable")
    scale: ma.pressed ? 0.93 : 1
    Behavior on scale { SpringAnimation { spring: 5; damping: 0.4; epsilon: 0.001 } }

    Column {
        anchors.centerIn: parent; spacing: 6
        Item {
            id: box
            width: it.iconPx + 18; height: width; anchors.horizontalCenter: parent.horizontalCenter
            MorphShape {
                anchors.fill: parent
                shape: ma.pressed ? "square" : ((it.hovered && it.hoverMorph) ? "cookie9" : (it.shapeName === "none" ? "square" : it.shapeName))
                color: (it.hovered || it.selected) ? it.pal.primaryContainer : it.pal.containerHigh
                opacity: it.shapeName === "none" ? ((it.hovered || it.selected) ? 1 : 0) : 1
                Behavior on opacity { NumberAnimation { duration: 160 } }
                spin: it.hovered && it.hoverMorph && !ma.pressed; spinPeriod: 9000
            }
            Image {
                id: ico
                property bool fallback: false
                anchors.centerIn: parent
                width: it.iconPx; height: it.iconPx
                sourceSize: Qt.size(it.iconPx * 2, it.iconPx * 2)
                fillMode: Image.PreserveAspectFit
                asynchronous: true; smooth: true; mipmap: true
                source: fallback ? it.src : it.papirusSrc
                onStatusChanged: if (status === Image.Error && !fallback) fallback = true
                Connections {
                    target: it
                    function onAppChanged() { ico.fallback = false }
                }
            }
            Rectangle {
                visible: it.editMode; width: 22; height: 22; radius: ma2.pressed ? 6 : 11
                anchors.top: parent.top; anchors.right: parent.right; anchors.margins: -4
                color: it.pinned ? it.pal.errorContainer : it.pal.primary
                Behavior on radius { NumberAnimation { duration: 140 } }
                GlyphIcon { anchors.centerIn: parent; width: 14; height: 14; glyph: it.pinned ? "close" : "add"
                    color: it.pinned ? it.pal.error : it.pal.fgOnPrimary }
                MouseArea { id: ma2; anchors.fill: parent; cursorShape: Qt.PointingHandCursor; onClicked: it.pinToggle() }
            }
        }
        StyledText {
            visible: it.showLabel; width: it.width - 8; anchors.horizontalCenter: parent.horizontalCenter
            text: it.app ? it.app.name : ""; elide: Text.ElideRight; horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 11; color: it.pal.fg
        }
    }
    MouseArea {
        id: ma; anchors.fill: parent; hoverEnabled: true; enabled: it.interactive; cursorShape: Qt.PointingHandCursor
        onClicked: it.editMode ? it.pinToggle() : it.launch()
    }
}
