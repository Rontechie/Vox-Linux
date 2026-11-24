# Source and asset audit from comment-cleaned.zip

Archive inventory: 1,186 files, 732 QML files, about 11.7 MB. It includes the Hydro shell, Nexus, welcome.qml, scripts, translations, fonts, icons, wallpapers, and sounds. The user confirms the Hydro project is GPL-3.0; `LICENSE` contains the full license text. Separate asset licenses still apply and must be preserved.

The archive contained old .bak/.pre/.before QML variants and Python bytecode; these are excluded from `hydro/`. AI-provider artwork and token-helper material were excluded during import, and the welcome text is Vox-branded. Hydro must remain free of AI features. Re-scan the active source before each release. The Google Cloud builder is separate infrastructure and does not add AI features to Vox.

Font/asset findings:

- Google Sans Flex is included in the archive with its own SIL Open Font License 1.1 text. User says it is already bundled in Hydro; keep its notice next to the font.
- Several lyric fonts include OFL notices: Anton, Archivo Black, Bangers, Great Vibes, Kaushan Script, Monoton, Permanent Marker, Pirata One, Playfair Display, and Yellowtail. Keep the matching notice file for each font. Verify the actual font file matches the notice and names before redistribution.
- User requested JetBrains Mono Nerd Font, Readex Pro, Space Grotesk, Material Symbols Rounded: these are not in the archive inventory. Stage from their official upstreams in vox-fonts and include each upstream OFL/license/notice. Do not fetch or redistribute them without retaining notices.
- The archive's Fluent icons, Hydro logos, wallpaper images, notification sound, and other image assets have no clear root-level license manifest. Verify upstream/source and include a NOTICE/license inventory before packaging. Do not assume the default wallpaper or logo is Vox-owned.
- The two attached Hyprland Lua files are personal configuration input, not included in the ISO as Lua. Selected keybinds were translated to Hyprland syntax; custom scripts referenced in the Lua file were not present in the ZIP, so those bindings were omitted.
