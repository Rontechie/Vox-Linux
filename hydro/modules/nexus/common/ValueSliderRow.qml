pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Layouts
import qs.modules.nexus.compat
import qs.modules.nexus.components
import qs.modules.nexus.components.controls
import qs.modules.nexus.services
import qs.modules.nexus.common

ConnectedRect {
    id: root

    property alias label: label.text
    property string subtext
    property string unit
    property int decimals: 0
    property real value
    property real from: 0
    property real to: 1
    property real stepSize: 0

    readonly property real norm: to > from ? Math.max(0, Math.min(1, (value - from) / (to - from))) : 0

    signal moved(value: real)

    function snap(n: real): real {
        let v = from + n * (to - from);
        if (stepSize > 0)
            v = Math.round(v / stepSize) * stepSize;
        return Math.max(from, Math.min(to, v));
    }

    Layout.fillWidth: true
    implicitHeight: rowLayout.implicitHeight + rowLayout.anchors.margins + rowLayout.anchors.topMargin

    RowLayout {
        id: rowLayout

        anchors.fill: parent
        anchors.margins: Tokens.padding.largeIncreased
        anchors.topMargin: Tokens.padding.large
        spacing: Tokens.spacing.medium

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Tokens.spacing.medium

            RowLayout {
                Layout.fillWidth: true
                spacing: Tokens.spacing.small

                StyledText {
                    id: label

                    Layout.fillWidth: true
                    font: Tokens.font.body.small
                    elide: Text.ElideRight
                }

                StyledText {
                    color: Colours.palette.m3outline
                    font: Tokens.font.body.small
                    text: root.value.toFixed(root.decimals) + root.unit
                }
            }

            StyledText {
                Layout.fillWidth: true
                visible: root.subtext
                text: root.subtext
                color: Colours.palette.m3outline
                font: Tokens.font.label.small
                elide: Text.ElideRight
            }

            CustomMouseArea {
                function onWheel(event: WheelEvent): void {
                    const step = root.stepSize > 0 ? root.stepSize : (root.to - root.from) / 20;
                    if (event.angleDelta.y > 0)
                        root.moved(Math.min(root.to, root.value + step));
                    else if (event.angleDelta.y < 0)
                        root.moved(Math.max(root.from, root.value - step));
                }

                Layout.fillWidth: true
                implicitHeight: Tokens.padding.medium * 2

                StyledSlider {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    implicitHeight: parent.implicitHeight

                    radius: Tokens.rounding.small
                    value: root.norm
                    enabled: root.enabled
                    onInteraction: v => root.moved(root.snap(v))
                }
            }
        }
    }
}
