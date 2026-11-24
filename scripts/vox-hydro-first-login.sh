#!/usr/bin/bash
set -euo pipefail

source_dir=/usr/share/hydro
user_dir=${XDG_DATA_HOME:-$HOME/.local/share}/hydro
state_dir=${XDG_STATE_HOME:-$HOME/.local/state}/vox
mkdir -p "$(dirname "$user_dir")" "$state_dir"
if [[ ! -e "$user_dir" && ! -L "$user_dir" ]]; then
  ln -s "$source_dir" "$user_dir"
fi
if [[ -L "$user_dir" && "$(readlink -f "$user_dir")" != "$source_dir" ]]; then
  echo "Hydro user link points elsewhere; leaving it unchanged." >&2
  exit 1
fi
