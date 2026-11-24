# Vox 0.1 QA checklist

| Area | Check | Expected result / clue |
|---|---|---|
| QML imports | QML_IMPORT_TRACE=1 qs -c ~/.local/share/hydro | Quickshell modules resolve; module-not-found means an RPM/subpackage is missing or build differs. |
| Quickshell features | rpm -q --whatprovides 'qt6qml(Quickshell.Hyprland)' 'qt6qml(Quickshell.Services.Pipewire)' 'qt6qml(Quickshell.Services.Mpris)' 'qt6qml(Quickshell.Services.Polkit)' | All are provided by installed Quickshell. |
| Session | echo "$XDG_SESSION_TYPE $WAYLAND_DISPLAY"; hyprctl version | Wayland and a responding compositor. |
| Shell startup | systemctl --user status vox-hydro-shell.service; journalctl --user -b -u vox-hydro-shell | One shell, no import/permission errors. |
| Audio/media | wpctl status; playerctl -l | PipeWire devices; MPRIS appears while a player runs. |
| Network/Bluetooth | nmcli general status; bluetoothctl show | NetworkManager and BlueZ work where hardware exists. |
| Polkit | rpm -q --whatprovides PolicyKit-authentication-agent; pgrep -af qs | One authentication agent; avoid starting a second agent. |
| PAM/keyring | Lock/unlock and inspect SDDM/user journal | PAM works; keyring unlock requires testing an actual password login, not live autologin. |
| Fonts/icons | fc-match 'Google Sans Flex'; fc-match 'Readex Pro'; gtk4-icon-browser | Fonts resolve and missing icons have a theme fallback. |
| Wallpaper/colors | Change wallpaper; inspect ~/.local/state/quickshell/user/generated/colors.json | Wallpaper changes; matugen writes Material colors. Missing Python packages often break scripts. |
| Codecs | ffmpeg -codecs and test sample media | Fedora ffmpeg-free has codec restrictions. Add RPM Fusion Free ffmpeg only when exact needed codecs are absent and redistribution is appropriate. |
| Clipboard/screenshots | wl-paste -l; grim /tmp/vox-shot.png | Clipboard and screenshot portals/screencopy work. Avoid broad Hyprland permission rules. |
| Screen share | Test Firefox and a Flatpak screen share | xdg-desktop-portal-hyprland/GTK backend and session environment work. |
| Live/install login | Boot ISO, install to fresh VM, reboot | Live autologin only; installed OS prompts for account/password. |
| Security | getenforce; firewall-cmd --state; ausearch -m AVC -ts boot | Enforcing, firewall running, no unexplained denials. |
