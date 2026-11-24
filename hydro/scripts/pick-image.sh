#!/usr/bin/env bash
title="${1:-Choose a picture}"
if command -v kdialog &>/dev/null; then
    kdialog --getopenfilename "$HOME" "image/*" --title "$title"
elif command -v zenity &>/dev/null; then
    zenity --file-selection --title="$title" --filename="$HOME/" --file-filter='Images | *.png *.jpg *.jpeg *.webp *.gif *.bmp *.svg'
elif command -v yad &>/dev/null; then
    yad --file --title="$title" --filename="$HOME/"
else
    notify-send -a "Hydro" -u critical "No file chooser found" "Install kdialog, zenity or yad." 2>/dev/null
fi
