#!/usr/bin/bash
set -u
source_dir=/usr/share/hydro
setup="$source_dir/scripts/setup-venv.sh"
state_dir=${XDG_STATE_HOME:-$HOME/.local/state}/vox
marker="$state_dir/python-venv-ready"
mkdir -p "$state_dir"
[[ -x "$setup" ]] || { echo "Missing Hydro venv setup script: $setup" >&2; exit 1; }
if [[ -e "$marker" ]]; then exit 0; fi
if "$setup"; then
  touch "$marker"
else
  echo "Hydro Python setup failed (network or wheel unavailable); retry after connecting." >&2
  exit 1
fi
