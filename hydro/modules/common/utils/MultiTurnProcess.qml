pragma ComponentBehavior: Bound
import QtQuick
import Quickshell.Io

Process {
    id: proc

    signal finished(string output)

    property list<var> sequence: []
    property int index: 0

    function runSequence(seq) {
        if (seq.length == 0)
            return;
        sequence = seq;
        running = false;
        index = -1;
        step();
    }

    function step(output) {
        index++;
        if (index >= sequence.length) {
            finished(output);
            return;
        }
        const nextItem = sequence[index];
        if (typeof nextItem === "function") {
            const nextOutput = nextItem(output);
            step(nextOutput);
        } else {
            if (nextItem.length > 0)
                command = nextItem;
            running = true;
        }
    }

    stdout: StdioCollector {
        onStreamFinished: {
            proc.step(text);
        }
    }
}
