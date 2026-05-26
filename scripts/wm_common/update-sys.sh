#!/usr/bin/env bash

# If the operating system is not Arch Linux, exit the script successfully
if [ ! -f /etc/arch-release ]; then
    exit 0
fi

# Helper to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Calculate updates for each service
AUR=$(yay -Qua | wc -l)
OFFICIAL=$(checkupdates | wc -l)

# Count flatpak updates only if flatpak is installed
if command_exists flatpak; then
    FLATPAK=$(flatpak remote-ls --updates 2>/dev/null | wc -l)
else
    FLATPAK=0
fi

# Case/switch for each service updates
case $1 in
    aur) echo " $AUR";;
    official) echo " $OFFICIAL";;
    flatpak) echo " $FLATPAK";;
esac

# If the parameter is "update", update all services
if [ "$1" = "update" ]; then
    # Build the update command dynamically
    UPDATE_CMD="yay -Syu --noconfirm"

    if command_exists flatpak; then
        UPDATE_CMD="$UPDATE_CMD && sudo flatpak update --assumeyes"
    fi

    if command_exists distrobox; then
        UPDATE_CMD="$UPDATE_CMD && distrobox upgrade --all"
    fi

    kitty --title update-sys sh -c "$UPDATE_CMD"
fi

# If there aren't any parameters, return the total number of updates
if [ "$1" = "" ]; then
    # Calculate total number of updates
    COUNT=$((OFFICIAL+AUR+FLATPAK))

    # If there are updates, the script will output the following:  Updates
    # If there are no updates, the script will output nothing.
    if [[ "$COUNT" = "0" ]]
    then
        echo ""
    else
        # This Update symbol is RTL. So &#x202d; is left-to-right override.
        echo " $COUNT"
    fi
    exit 0
fi

