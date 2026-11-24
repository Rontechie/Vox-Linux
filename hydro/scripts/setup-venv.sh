#!/usr/bin/env bash
set -e
VENV="${HYDRO_VIRTUAL_ENV:-${XDG_STATE_HOME:-$HOME/.local/state}/quickshell/.venv}"
mkdir -p "$(dirname "$VENV")"
python3 -m venv --system-site-packages "$VENV"
"$VENV/bin/pip" install --upgrade materialyoucolor pillow numpy opencv-python-headless
echo "Hydro venv ready at $VENV"
