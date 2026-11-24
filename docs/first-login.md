# First login sequence

1. SDDM launches the Hyprland session from /usr/share/wayland-sessions/vox-hyprland.desktop.
2. The /etc/skel Hyprland config starts vox-hydro-session.target.
3. vox-hydro-shell.service creates ~/.local/share/hydro as a symlink to /usr/share/hydro and runs qs -c ~/.local/share/hydro.
4. Hydro's own FirstRunExperience singleton detects its first-run marker, invokes scripts/colors/switchwall.sh with the shipped default wallpaper, then opens welcome.qml with qs -p. The marker prevents opening welcome again. The text key is Vox branded.
5. vox-hydro-python-setup.service runs scripts/setup-venv.sh in the background; that script builds a per-user venv and installs materialyoucolor, Pillow, NumPy, and opencv-python-headless. It needs internet unless the build later bundles Python wheels. Failure is nonfatal to shell startup and the service can be retried after connecting.
6. switchwall.sh invokes matugen and the Hydro Python color script; generated palette output is read by Quickshell from the user state directory.

Do not add welcome opening to both the Hyprland config and the Hydro FirstRunExperience service: that would open it twice. The default wallpaper is the bundled Hydro image; its redistribution license still needs audit.
