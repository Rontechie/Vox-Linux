import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root

    property string title
    property string icon: ""
    property bool collapsible: false
    property bool expanded: true
    default property alias contentData: sectionContent.data

    property int enterDelay: 0
    function siblingIndex() {
        if (!parent) return 0;
        const c = parent.children;
        for (let i = 0; i < c.length; i++)
            if (c[i] === root) return i;
        return 0;
    }
    function playEnter() {
        enterDelay = Math.min(siblingIndex() * 45, 360);
        enter.restart();
    }

    Layout.fillWidth: true
    Layout.fillHeight: true
    implicitHeight: mainColumn.implicitHeight + SettingsTheme.spacingL * 2
    radius: Math.max(SettingsTheme.cornerRadius, 26)
    color: SettingsTheme.surface
    border.width: 1
    border.color: SettingsTheme.withAlpha(SettingsTheme.outline, 0.6)
    clip: true
    opacity: 0
    transform: Translate { id: lift; y: 18 }

    Component.onCompleted: playEnter()
    onVisibleChanged: if (visible) playEnter()

    SequentialAnimation {
        id: enter
        PauseAnimation { duration: root.enterDelay }
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; from: 0; to: 1; duration: SettingsMotion.effectsMs + 80 }
            NumberAnimation {
                target: lift; property: "y"; from: 18; to: 0
                duration: SettingsMotion.spatialMs
                easing.type: Easing.BezierSpline
                easing.bezierCurve: SettingsMotion.spatial
            }
        }
    }

    Behavior on implicitHeight {
        NumberAnimation {
            duration: SettingsMotion.effectsMs
            easing.type: Easing.BezierSpline
            easing.bezierCurve: SettingsMotion.effects
        }
    }

    ColumnLayout {
        id: mainColumn
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: SettingsTheme.spacingL
        }
        spacing: SettingsTheme.spacingM

        RowLayout {
            Layout.fillWidth: true
            visible: root.title !== "" || root.icon !== ""
            spacing: SettingsTheme.spacingM

            MaterialSymbol {
                visible: root.icon !== ""
                text: root.icon
                iconSize: SettingsTheme.iconSize
                color: SettingsTheme.primary
            }
            StyledText {
                Layout.fillWidth: true
                text: root.title
                font.pixelSize: SettingsTheme.fontSizeLarge
                font.weight: Font.Medium
                color: SettingsTheme.surfaceText
            }
            MaterialSymbol {
                visible: root.collapsible
                text: "expand_more"
                iconSize: SettingsTheme.iconSize - 2
                color: SettingsTheme.surfaceVariantText
                rotation: root.expanded ? 180 : 0
                Behavior on rotation {
                    NumberAnimation {
                        duration: SettingsMotion.fastSpatialMs
                        easing.type: Easing.BezierSpline
                        easing.bezierCurve: SettingsMotion.fastSpatial
                    }
                }
            }
            TapHandler {
                enabled: root.collapsible
                onTapped: root.expanded = !root.expanded
            }
        }

        ColumnLayout {
            id: sectionContent
            Layout.fillWidth: true
            visible: !root.collapsible || root.expanded
            spacing: SettingsTheme.spacingXS
        }
    }
}
