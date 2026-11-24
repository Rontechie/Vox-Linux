import qs
import qs.modules.common
import QtQuick

Item {
    id: root
    property var widgets: []
    readonly property string style: Config.options.bar.style
    readonly property real pillHeight: Appearance.sizes.baseBarHeight - 8
    readonly property real groupPad: style === "grouped" ? 8 : 0

    implicitWidth: row.implicitWidth + groupPad * 2
    implicitHeight: Appearance.sizes.baseBarHeight

    Rectangle { // single background for "grouped" style
        visible: root.style === "grouped" && row.implicitWidth > 0
        anchors.fill: parent
        anchors.topMargin: 4
        anchors.bottomMargin: 4
        radius: Appearance.rounding.full
        color: Appearance.colors.colLayer1
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: root.style === "pills" ? 4 : 8

        Repeater {
            model: root.widgets
            delegate: Item {
                id: cell
                required property string modelData
                visible: widget.shown
                width: widget.shown ? widget.implicitWidth + (root.style === "pills" ? 16 : 0) : 0
                height: root.pillHeight

                Rectangle {
                    anchors.fill: parent
                    visible: root.style === "pills"
                    radius: Appearance.rounding.full
                    color: Appearance.colors.colLayer1
                }
                BarWidget {
                    id: widget
                    anchors.centerIn: parent
                    widgetId: cell.modelData
                }
            }
        }
    }
}
