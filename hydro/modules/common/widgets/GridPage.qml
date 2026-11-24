import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

StyledFlickable {
    id: root

    property bool forceWidth: false          // accepted so a page can switch between ContentPage and GridPage
    property real baseWidth: 600             // accepted for the same reason; the grid ignores it
    property real bottomContentPadding: 60
    property real margin: 24
    property real gap: 16
    property int minColumnWidth: 340
    property int maxColumns: 4

    readonly property int fullSpan: grid.columns
    function span(n) { return Math.max(1, Math.min(n, grid.columns)); }

    default property alias contentData: grid.data

    clip: true
    contentHeight: grid.implicitHeight + root.margin * 2 + root.bottomContentPadding

    GridLayout {
        id: grid
        x: root.margin
        y: root.margin
        width: root.width - root.margin * 2
        columns: Math.max(1, Math.min(root.maxColumns, Math.floor((width + root.gap) / (root.minColumnWidth + root.gap))))
        columnSpacing: root.gap
        rowSpacing: root.gap
    }
}
