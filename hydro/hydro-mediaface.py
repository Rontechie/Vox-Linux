#!/usr/bin/env python3
"""Adds the "Media Face" bar widget (ported from Serpantinum's MediaFace.qml).
Usage: python3 hydro-mediaface.py [~/.local/share/hydro]   (run after unzipping hydro-mediaface.zip there)
Then add it in Settings > Bar > Widget List ("Media Face"), tweak it in Nexus > Bar > Media face.
Idempotent; backups: <file>.premedia.
Edits: Config.qml, modules/bar/HydroBarWidget.qml, modules/settings/hydro/WidgetLanes.qml, Nexus BarPage.qml"""
import os, shutil, sys

root = os.path.expanduser(sys.argv[1] if len(sys.argv) > 1 else "~/.local/share/hydro")
problems = []

def edit(rel, fn, marker):
    path = os.path.join(root, rel)
    if not os.path.exists(path):
        problems.append(f"{rel}: not found"); return
    s = open(path).read()
    if marker in s:
        print(f"= {rel}: already patched"); return
    new = fn(s)
    if new is None:
        problems.append(f"{rel}: expected text not found (file differs from the one I saw)"); return
    shutil.copy(path, path + ".premedia")
    open(path, "w").write(new)
    print(f"+ {rel}")

def rep(s, old, new):
    return s.replace(old, new, 1) if s is not None and s.count(old) == 1 else None

def config(s):
    hide = '                    property bool hideWhenIdle: false    // disappear while nothing is playing\n'
    extra = '                    property bool replaceMedia: true     // the "Media" and "Media Player" widgets draw this face too\n'
    if "property JsonObject mediaFace" in s:  # upgrade from the first version
        return rep(s, hide, hide + extra)
    return rep(s, '                property string clockStyle: "default" // default | classic | badge | material\n',
        '''                property string clockStyle: "default" // default | classic | badge | material
                property JsonObject mediaFace: JsonObject {
                    property string infoMode: "duration" // line under the title: "duration" (01:24 / 03:42) or "author"
                    property real width: 120             // width of the title column (px)
                    property bool showIcon: true         // the cover
                    property bool showControls: true     // previous / play-pause / next
''' + hide + extra + '''                }
''')
edit("modules/common/Config.qml", config, "property bool replaceMedia")

def bar(s):
    if "mediaFaceC" not in s:  # first install
        s = rep(s, '            case "mediaPlayer": return mediaPlayerC;\n',
                '            case "mediaPlayer": return mediaPlayerC;\n            case "mediaFace": return mediaFaceC;\n')
        s = rep(s, "    Component {\n        id: clockC\n", '''    Component {
        id: mediaFaceC
        HydroMediaFace {} // Serpantinum media face: cover, scrolling title, time / author, controls
    }

    Component {
        id: clockC
''')
    s = rep(s, '            case "mediaPlayer": return mediaPlayerC;\n',
            '            case "media": return Config.options.bar.mediaFace.replaceMedia ? mediaFaceC : classicC;\n'
            '            case "mediaPlayer": return Config.options.bar.mediaFace.replaceMedia ? mediaFaceC : mediaPlayerC;\n')
    return s
edit("modules/bar/HydroBarWidget.qml", bar, "mediaFace.replaceMedia")

edit("modules/settings/hydro/WidgetLanes.qml", lambda s: rep(s,
    '        mediaPlayer:   { name: "Media Player",    icon: "play_circle" },\n',
    '        mediaPlayer:   { name: "Media Player",    icon: "play_circle" },\n        mediaFace:     { name: "Media Face",      icon: "album" },\n'),
    "mediaFace:")

def page(s):
    hide = '            CfgToggle { obj: root.bar.mediaFace; key: "hideWhenIdle"; text: Tr.tr("Hide while nothing is playing") }\n'
    if 'key: "infoMode"' in s:  # upgrade from the first version
        return rep(s, hide, hide + '            CfgToggle { obj: root.bar.mediaFace; key: "replaceMedia"; text: Tr.tr("Use it for the Media and Media Player widgets too") }\n')
    block = '''        SectionHeader {
            text: Tr.tr("Media face")
        }

        RowGroup {
            CfgSelect {
                obj: root.bar.mediaFace
                key: "infoMode"
                label: Tr.tr("Line under the title")
                options: [
                    { text: Tr.tr("Time (01:24 / 03:42)"), value: "duration" },
                    { text: Tr.tr("Artist"), value: "author" }
                ]
            }
            CfgSlider {
                obj: root.bar.mediaFace
                key: "width"
                label: Tr.tr("Title width")
                from: 80
                to: 280
                stepSize: 10
                unit: " px"
            }
            CfgToggle { obj: root.bar.mediaFace; key: "showIcon"; text: Tr.tr("Show the cover") }
            CfgToggle { obj: root.bar.mediaFace; key: "showControls"; text: Tr.tr("Show previous / play / next") }
            CfgToggle { obj: root.bar.mediaFace; key: "hideWhenIdle"; text: Tr.tr("Hide while nothing is playing") }
            CfgToggle { obj: root.bar.mediaFace; key: "replaceMedia"; text: Tr.tr("Use it for the Media and Media Player widgets too") }
        }

'''
    return rep(s, '        SectionHeader {\n            text: Tr.tr("Widget capsules")\n        }\n',
               block + '        SectionHeader {\n            text: Tr.tr("Widget capsules")\n        }\n')
edit("modules/nexus/pages/hydro/BarPage.qml", page, 'key: "replaceMedia"')

if problems:
    print("\nCould not patch:"); [print("  -", p) for p in problems]; sys.exit(1)
print('\nDone. Restart Hydro, then add "Media Face" in Settings > Bar > Widget List.')
