#!/usr/bin/env python3
"""Keeps the launcher card off the bar. Usage: python3 hydro-launcher-fixoverlap.py [~/.local/share/hydro]
Idempotent. Backup: modules/launcher/Launcher.qml.preoverlap"""
import os, shutil, sys

root = os.path.expanduser(sys.argv[1] if len(sys.argv) > 1 else "~/.local/share/hydro")
p = os.path.join(root, "modules/launcher/Launcher.qml")
s = open(p).read()
if "barClearance" in s:
    sys.exit("already patched")
old_a = "        anchors {\n            left: true\n            top: !Config.options.bar.bottom\n            bottom: Config.options.bar.bottom\n        }\n"
if old_a not in s:
    sys.exit("anchor not found in Launcher.qml. Send me that file and I'll patch it directly.")
new_a = old_a + '''
        readonly property real barClearance: Config.options.bar.autoHide.enable ? 0 : Appearance.sizes.barHeight
        margins {
            top: Config.options.bar.bottom ? 0 : barClearance
            bottom: Config.options.bar.bottom ? barClearance : 0
        }
'''
shutil.copy(p, p + ".preoverlap")
open(p, "w").write(s.replace(old_a, new_a, 1))
print("patched modules/launcher/Launcher.qml (backup: Launcher.qml.preoverlap)")
print("restart: pkill quickshell; qs -c hydro")
