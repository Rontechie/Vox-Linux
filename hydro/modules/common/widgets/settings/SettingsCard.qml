import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets

Rectangle {
    id: root

    property string title: ""
    property string iconName: ""
    property bool collapsible: false
    property bool expanded: true
    property string tab: ""
    property var tags: []
    property string settingKey: ""

    default property alias content: contentColumn.data
    readonly property bool hasHeader: title !== "" || iconName !== ""

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
        NumberAnimation { duration: SettingsTheme.shortDuration; easing.type: Easing.OutCubic }
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
            visible: root.hasHeader
            spacing: SettingsTheme.spacingM

            MaterialSymbol {
                visible: root.iconName !== ""
                text: root.iconName
                iconSize: SettingsTheme.iconSize
                color: SettingsTheme.primary
            }
            StyledText {
                text: root.title
                font.pixelSize: SettingsTheme.fontSizeLarge
                font.weight: Font.Medium
                color: SettingsTheme.surfaceText
                Layout.fillWidth: true
            }
            MaterialSymbol {
                visible: root.collapsible
                text: root.expanded ? "expand_less" : "expand_more"
                iconSize: SettingsTheme.iconSize - 2
                color: SettingsTheme.surfaceVariantText
            }
            TapHandler {
                enabled: root.collapsible
                onTapped: root.expanded = !root.expanded
            }
        }

        ColumnLayout {
            id: contentColumn
            Layout.fillWidth: true
            visible: !root.collapsible || root.expanded
            spacing: SettingsTheme.spacingXS
        }
    }
}
