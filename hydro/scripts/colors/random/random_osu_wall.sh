#!/usr/bin/env bash

get_pictures_dir() {
    if command -v xdg-user-dir &> /dev/null; then
        xdg-user-dir PICTURES
        return
    fi

    local config_file="${XDG_CONFIG_HOME:-$HOME/.config}/user-dirs.dirs"
    if [ -f "$config_file" ]; then
        local pictures_path
        pictures_path=$(source "$config_file" >/dev/null 2>&1; echo "$XDG_PICTURES_DIR")
        echo "${pictures_path/#\$HOME/$HOME}"
        return
    fi

    echo "$HOME/Pictures"
}

QUICKSHELL_CONFIG_NAME="hydro"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
PICTURES_DIR=$(get_pictures_dir)
CONFIG_DIR="$XDG_CONFIG_HOME/quickshell/$QUICKSHELL_CONFIG_NAME"
CACHE_DIR="$XDG_CACHE_HOME/quickshell"
STATE_DIR="$XDG_STATE_HOME/quickshell"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$PICTURES_DIR/Wallpapers"

notify() { notify-send -a "Wallpaper switcher" "$1" "$2" 2>/dev/null; echo "[random] $1 $2" >&2; }
for dep in curl jq; do
    command -v "$dep" &>/dev/null || { notify "Missing dependency" "Install $dep"; exit 1; }
done

response=$(curl -fsSL --max-time 20 "https://osu.ppy.sh/api/v2/seasonal-backgrounds") \
    || { notify "osu! failed" "Could not reach osu.ppy.sh"; exit 1; }
images=$(echo "$response" | jq '.backgrounds | length' 2>/dev/null)
[ -z "$images" ] || [ "$images" -eq 0 ] && { notify "osu! failed" "No backgrounds in response"; exit 1; }
randomIndex=$((RANDOM % images))
link=$(echo "$response" | jq -r ".backgrounds[$randomIndex].url")
ext="${link##*.}"
ext="${ext%%\?*}"
downloadPath="$PICTURES_DIR/Wallpapers/random_wallpaper.$ext"
configPath="$XDG_CONFIG_HOME/hydro/config.json"
currentWallpaperPath=$(jq -r '.background.wallpaperPath // empty' "$configPath" 2>/dev/null)
if [ "$downloadPath" == "$currentWallpaperPath" ]; then
    downloadPath="$PICTURES_DIR/Wallpapers/random_wallpaper-1.$ext"
fi
curl -fsSL --max-time 120 "$link" -o "$downloadPath" \
    || { notify "Download failed" "$link"; exit 1; }
bash "$SCRIPT_DIR/../switchwall.sh" --image "$downloadPath"
