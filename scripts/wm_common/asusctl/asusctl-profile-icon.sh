#!/bin/bash
# asusctl-profile-icon.sh
# Returns a Nerd Font symbol for the active asusctl power profile.
# Codepoints verified from Nerd Fonts v3.5.1 glyphnames.json [16]

profile=$(asusctl profile get | awk '/^Active profile:/ {print $3}')

case "$profile" in
    "Quiet")
        printf '\uf186'  # fa-moon  U+F186
        ;;
    "Performance")
        printf '\uf0e7'  # fa-bolt  U+F0E7
        ;;
    "Balanced")
        printf '\uf24e'  # fa-balance_scale  U+F24E
        ;;
    *)
        printf '\uf013'  # fa-cog  U+F013 (fallback)
        ;;
esac

