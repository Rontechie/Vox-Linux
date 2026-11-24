import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root
    property bool first: false
    property bool last: false
    property bool clickable: true
    property bool disabled: false
    property real vPadding: 12
    property real hPadding: 20
    readonly property bool pressed: area.pressed
    readonly property bool hovered: area.containsMouse
    default property alias content: body.data
    signal clicked()

    Layout.fillWidth: true
    implicitHeight: body.implicitHeight + vPadding * 2
    color: Appearance.m3colors.m3surfaceContainer

    readonly property real big: 28
    readonly property real small: 4
    topLeftRadius: first ? big : small
    topRightRadius: topLeftRadius
    bottomLeftRadius: last ? big : small
    bottomRightRadius: bottomLeftRadius
    Behavior on topLeftRadius { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
    Behavior on bottomLeftRadius { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }

    Rectangle {
        anchors.fill: parent
        topLeftRadius: root.topLeftRadius; topRightRadius: root.topRightRadius
        bottomLeftRadius: root.bottomLeftRadius; bottomRightRadius: root.bottomRightRadius
        color: Appearance.m3colors.m3onSurface
        opacity: root.disabled ? 0 : root.pressed ? 0.12 : root.hovered && root.clickable ? 0.07 : 0
        Behavior on opacity { NumberAnimation { duration: 120 } }
    }
    MouseArea {
        id: area
        anchors.fill: parent
        hoverEnabled: true
        enabled: root.clickable && !root.disabled
        cursorShape: root.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: root.clicked()
    }
    ColumnLayout {
        id: body
        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter
                  leftMargin: root.hPadding; rightMargin: root.hPadding }
        opacity: root.disabled ? 0.5 : 1
    }
}
