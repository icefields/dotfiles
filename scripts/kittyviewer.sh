#!/usr/bin/env bash

shopt -s nullglob

exts=("*.png" "*.jpg" "*.jpeg" "*.webp" "*.gif")

# ----------------------------
# BUILD IMAGE LIST (IMPORTANT FIXED LOGIC)
# ----------------------------
if [ "$#" -gt 0 ]; then
    if [ "$#" -eq 1 ]; then
        input="$1"
        dir="$(dirname "$input")"
        base="$(basename "$input")"

        images=()
        for ext in "${exts[@]}"; do
            images+=( "$dir"/$ext )
        done

        # sort safely
        IFS=$'\n' images=($(printf '%s\n' "${images[@]}" | sort -V))
        unset IFS

        # find clicked image index
        index=0
        for i in "${!images[@]}"; do
            [[ "$(basename "${images[$i]}")" == "$base" ]] && index=$i && break
        done
    else
        images=("$@")
        IFS=$'\n' images=($(printf '%s\n' "${images[@]}" | sort -V))
        unset IFS
        index=0
    fi
else
    images=( "$PWD"/*.png "$PWD"/*.jpg "$PWD"/*.jpeg "$PWD"/*.webp "$PWD"/*.gif )
    IFS=$'\n' images=($(printf '%s\n' "${images[@]}" | sort -V))
    unset IFS
    index=0
fi

total=${#images[@]}

if [ "$total" -eq 0 ]; then
    echo "No images found."
    exit 1
fi

# ----------------------------
# MAIN LOOP
# ----------------------------
while true; do
    clear
    kitty +kitten icat --clear "${images[$index]}"

    echo
    echo "[ $((index+1)) / $total ] ${images[$index]}"
    echo "←/→ navigate | q quit"

    IFS= read -rsn1 key

    case "$key" in
        q|Q)
            clear
            exit 0
            ;;
        $'\e')
            read -rsn2 key
            case "$key" in
                "[C") ((index = (index + 1) % total)) ;;
                "[D") ((index = (index - 1 + total) % total)) ;;
            esac
            ;;
    esac
done

