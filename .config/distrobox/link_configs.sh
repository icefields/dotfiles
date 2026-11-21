#!/usr/bin/env bash
#
# link_configs.sh - Symlink dotfiles from source to destination home directory
#
# Usage:
#   ./link_configs.sh /home/lucie/dotfiles /home/lucie
#
# Arguments:
#   homeDirSource - Directory containing the original config files/dirs
#   homeDirDest   - Destination home directory where symlinks will be created
#
# Notes:
#   - Edit the 'paths' array below to add/remove configurations
#   - Handles both files and directories (e.g. .config/fish/config.fish)
#   - Parent directories are created automatically in the destination
#   - Existing symlinks are overwritten (-f flag)

homeDirSource="$1"
homeDirDest="$2"

# Those dirs should exist?
# mkdir -p /mnt/lucie/distrobox-home/music/.config/fish &&
# mkdir -p /mnt/lucie/distrobox-home/music/.config/fontconfig &&
# mkdir -p /mnt/lucie/distrobox-home/music/.local/share &&

paths=(
    ".config/fontconfig" # .config/fontconfig/fonts.conf
    ".local/share"
    ".config/gtk-3.0"
    ".config/gtk-4.0"
    ".config/qt5ct"
    ".config/qt6ct"
    ".config/Kvantum"
    ".config/fish/config.fish"
    ".config/fish/conf.d"
    ".config/fish/functions" # /home/lucie/.config/fish/completions
    ".config/kitty"
    ".config/nvim"
    ".local/share/themes"
    ".local/share/icons"
    ".local/share/fonts"
    "scripts"
    ".shell_env"
)

for p in "${paths[@]}"; do
    mkdir -p "${homeDirDest}/$(dirname "${p}")"
    ln -sf "${homeDirSource}/${p}" "${homeDirDest}/${p}"
done

