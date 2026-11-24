#!/usr/bin/bash
set -euo pipefail
repo=$(cd "$(dirname "$0")/.." && pwd)
version=${1:-0.1.0}
source_dir=${2:-$repo/hydro}
[[ -d "$source_dir" ]] || { echo "Hydro tree missing: $source_dir" >&2; exit 1; }
[[ -f "$source_dir/LICENSE" ]] || { echo "Add the confirmed upstream Hydro LICENSE before packaging." >&2; exit 2; }
mkdir -p "$repo/work/rpmsources/hydro-$version" "$repo/work/rpmsources/integration"
cp -a "$source_dir/." "$repo/work/rpmsources/hydro-$version/"
mkdir -p "$repo/work/rpmsources/integration/scripts" "$repo/work/rpmsources/integration/systemd/user"
cp "$repo/scripts/vox-hydro-first-login.sh" "$repo/scripts/vox-hydro-python-setup.sh" "$repo/work/rpmsources/integration/scripts/"
cp "$repo/systemd/user/vox-hydro-session.target" "$repo/systemd/user/vox-hydro-shell.service" "$repo/systemd/user/vox-hydro-python-setup.service" "$repo/work/rpmsources/integration/systemd/user/"
cp "$repo/packaging/vox-hydro-shell/session.desktop" "$repo/work/rpmsources/integration/"
cp "$repo/configs/hypr/hyprland.lua" "$repo/configs/hypr/appearance.lua" "$repo/work/rpmsources/integration/"
tar -C "$repo/work/rpmsources" -czf "$HOME/rpmbuild/SOURCES/hydro-$version.tar.gz" "hydro-$version"
tar -C "$repo/work/rpmsources" -czf "$HOME/rpmbuild/SOURCES/vox-hydro-integration-$version.tar.gz" integration
