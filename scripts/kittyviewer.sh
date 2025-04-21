#!/bin/bash

# Load images
shopt -s nullglob
images=( *.png *.jpg *.jpeg )
shopt -u nullglob

if [ ${#images[@]} -eq 0 ]; then
    echo "No images found."
    exit 1
fi

index=0
total=${#images[@]}

show_image() {
    clear  # Clear the entire terminal screen
    kitty +kitten icat "${images[$index]}"
    echo
    echo "[Image $((index + 1)) of $total]: ${images[$index]}"
    echo "Use ← / → to navigate, q to quit"
}

# Main loop
while true; do
    show_image

    # Read keypress
    IFS= read -rsn1 key
    if [[ $key == $'\e' ]]; then
        read -rsn2 key  # Get the full escape sequence for arrows
    fi

    case "$key" in
        '[C')  # Right arrow
            if (( index < total - 1 )); then
                ((index++))
            fi
            ;;
        '[D')  # Left arrow
            if (( index > 0 )); then
                ((index--))
            fi
            ;;
        q|Q)
            clear
            break
            ;;
    esac
done

