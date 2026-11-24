#!/usr/bin/env bash
COLOR_FILE_PATH="${XDG_STATE_HOME:-$HOME/.local/state}/quickshell/user/generated/color.txt"

settings_paths=(
    "${XDG_CONFIG_HOME:-$HOME/.config}/Code/User/settings.json"
    "${XDG_CONFIG_HOME:-$HOME/.config}/VSCodium/User/settings.json"
    "${XDG_CONFIG_HOME:-$HOME/.config}/Code - OSS/User/settings.json"
    "${XDG_CONFIG_HOME:-$HOME/.config}/Code - Insiders/User/settings.json"
    "${XDG_CONFIG_HOME:-$HOME/.config}/Cursor/User/settings.json"
    "${XDG_CONFIG_HOME:-$HOME/.config}/Antigravity/User/settings.json"
    "${XDG_CONFIG_HOME:-$HOME/.config}/Windsurf/User/settings.json"
    
)

new_color=$(cat "$COLOR_FILE_PATH")

for CODE_SETTINGS_PATH in "${settings_paths[@]}"; do
    if [[ -f "$CODE_SETTINGS_PATH" ]]; then
        if grep -q '"material-code.primaryColor"' "$CODE_SETTINGS_PATH"; then
            sed -i -E \
                "s/(\"material-code.primaryColor\"\s*:\s*\")[^\"]*(\")/\1${new_color}\2/" \
                "$CODE_SETTINGS_PATH"
        else # If the key is not already there, add it
            sed -i '$ s/}/,\n  "material-code.primaryColor": "'${new_color}'"\n}/' "$CODE_SETTINGS_PATH"
            sed -i '$ s/,\n,/,/' "$CODE_SETTINGS_PATH"
        fi
    fi
done

