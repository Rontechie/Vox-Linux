import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

StyledFlickable {
    id: root
    default property alias content: col.data
    readonly property real cappedWidth: Math.min(800, width)
    clip: true
    contentWidth: width
    contentHeight: col.implicitHeight + 40
    topMargin: 8

    ColumnLayout {
        id: col
        width: root.cappedWidth
        x: (root.width - width) / 2
        spacing: 2
    }
}
