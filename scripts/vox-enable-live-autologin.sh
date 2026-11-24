#!/usr/bin/bash
set -euo pipefail
# The live root is an overlay with volatile /etc. Installed systems boot from
# disk and have no /run/initramfs/live, so this never enables installed autologin.
[[ -d /run/initramfs/live ]] || exit 0
install -d -m 0755 /etc/sddm.conf.d
cat > /etc/sddm.conf.d/90-vox-live-autologin.conf <<'CONF'
[Autologin]
User=liveuser
Session=vox-hyprland.desktop
Relogin=false
CONF
