import QtQuick
import qs.modules.common.widgets

MaterialLoadingIndicator {
    id: el
    property bool running: true
    property real size: 32
    implicitSize: size
    loading: running
}
