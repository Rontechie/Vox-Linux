pragma Singleton
import QtQuick
import Quickshell

Singleton {
    id: root
    property var stack: []                      // [{ title, source }]
    readonly property bool isSubPage: stack.length > 1
    readonly property var current: stack.length > 0 ? stack[stack.length - 1] : null

    signal pickFile(string tag, string title)
    signal filePicked(string tag, string path)

    function reset(title, source) { stack = [{ title: title, source: source }] }
    function push(title, source) { stack = stack.concat([{ title: title, source: source }]) }
    function pop() { if (stack.length > 1) stack = stack.slice(0, stack.length - 1) }
}
