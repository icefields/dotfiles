#!/usr/bin/env bash
# Launch the best available sound settings panel, or manually choose via parameter.

# Supported tools (in order of preference):
#   gnome-control-center sound
#   systemsettings6 kcm_pulseaudio
#   systemsettings5 kcm_pulseaudio
#   cinnamon-settings sound
#   pavucontrol

has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

launch() {
    echo "→ Launching: $*"
    exec "$@"
}

show_help() {
    cat <<EOF
Usage: sound-settings.sh [option]

Options:
  gnome       Launch GNOME Sound Settings (gnome-control-center sound)
  kde6        Launch KDE Plasma 6 Sound Settings (systemsettings6 kcm_pulseaudio)
  kde5        Launch KDE Plasma 5 Sound Settings (systemsettings5 kcm_pulseaudio)
  cinnamon    Launch Cinnamon Sound Settings (cinnamon-settings sound)
  pavucontrol Launch PulseAudio Volume Control
  auto        Automatically detect and launch the best available (default)
  help        Show this help message

Examples:
  sound-settings.sh           # auto-detect
  sound-settings.sh kde6      # manually choose KDE Plasma 6
EOF
}

# --- Main ---

choice="${1:-auto}"

case "$choice" in
    help|-h|--help)
        show_help
        exit 0
        ;;
    gnome)
        if has_cmd gnome-control-center; then
            launch gnome-control-center sound
        else
            echo "Error: gnome-control-center not found."
            exit 1
        fi
        ;;
    kde6)
        if has_cmd systemsettings6; then
            launch systemsettings6 kcm_pulseaudio
        else
            echo "Error: systemsettings6 not found."
            exit 1
        fi
        ;;
    kde5)
        if has_cmd systemsettings5; then
            launch systemsettings5 kcm_pulseaudio
        else
            echo "Error: systemsettings5 not found."
            exit 1
        fi
        ;;
    cinnamon)
        if has_cmd cinnamon-settings; then
            launch cinnamon-settings sound
        else
            echo "Error: cinnamon-settings not found."
            exit 1
        fi
        ;;
    pavucontrol)
        if has_cmd pavucontrol; then
            launch pavucontrol
        else
            echo "Error: pavucontrol not found."
            exit 1
        fi
        ;;
    auto|*)
        echo "Auto-detecting sound settings tool..."
        if has_cmd gnome-control-center; then
            launch gnome-control-center sound
        elif has_cmd systemsettings6; then
            launch systemsettings6 kcm_pulseaudio
        elif has_cmd systemsettings5; then
            launch systemsettings5 kcm_pulseaudio
        elif has_cmd cinnamon-settings; then
            launch cinnamon-settings sound
        elif has_cmd pavucontrol; then
            launch pavucontrol
        else
            echo "⚠️  No sound settings tool found."
            echo "   Install one, e.g.: sudo pacman -S pavucontrol"
            exit 1
        fi
        ;;
esac

