import QtQuick
import QtQuick.Layouts
import qs.modules.common

Rectangle {
    id: card
    default property alias content: inner.data
    property real pad: 20
    implicitHeight: inner.implicitHeight + pad * 2
    radius: 28
    readonly property color base: Appearance.m3colors.m3surfaceContainerHigh
    color: Qt.rgba(base.r, base.g, base.b, 0.72)
    border.width: 1
    border.color: Qt.rgba(1, 1, 1, 0.12)
    ColumnLayout {
        id: inner
        anchors { left: parent.left; right: parent.right; top: parent.top; margins: card.pad }
        spacing: 10
    }
}
