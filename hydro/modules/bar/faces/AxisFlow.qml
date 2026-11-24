import QtQuick

Grid {
    property bool vertical: false
    flow: vertical ? Grid.TopToBottom : Grid.LeftToRight
    rows: vertical ? 99 : 1
    columns: vertical ? 1 : 99
}
