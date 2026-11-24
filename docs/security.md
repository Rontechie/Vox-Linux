# SELinux and firewall

- Keep SELinux enforcing and firewalld enabled. Do not disable either to work around a shell bug.
- Static QML belongs under /usr/share/hydro; executable helpers under /usr/libexec. Keep user data owned by the user. Do not copy executable code into home at first boot.
- Likely SELinux denial sources include symlink traversal, scripts launched from /usr/share/hydro, screenshot/screencopy, PAM lock screen, Python venv creation, wallpaper writes under ~/.config and ~/.local/state, and compositor GPU device access. Review ausearch -m AVC -ts boot and journalctl -b. Add narrowly scoped SELinux policy only for reproducible denials.
- Run Quickshell/Hyprland as the desktop user. Use portals and polkit rather than broad chmod rules.
- Firewall defaults: firewalld on, public zone, no inbound services. Verify Kickstart firewalld service names with firewall-cmd --get-services; remove any invalid service exception.
