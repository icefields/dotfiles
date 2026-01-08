#!/usr/bin/env bash
set -euo pipefail

# TODO: before downloading check if the current is the latest version.

update_github_app() {
    local appname="$1"
    local github_url="$2"

    if [[ -z "$appname" || -z "$github_url" ]]; then
        echo "Usage: update_github_app <appname> <github_releases_url>"
        return 1
    fi

    local APP_DIR="$HOME/apps"
    local OLD_DIR="$APP_DIR/OLD-VERSIONS"
    local APP_PATH="$APP_DIR/$appname"

    echo "Updating $appname"
    echo "From: $github_url"

    # Backup current version (if it exists)
    if [[ -f "$APP_PATH" ]]; then
        "$HOME/scripts/shell_common/backup.sh" "$APP_PATH"
    fi

    # Ensure OLD-VERSIONS directory exists
    mkdir -p "$OLD_DIR"

    # Move old backups if any exist
    shopt -s nullglob
    local backups=("$APP_DIR/$appname".*.bck)
    if (( ${#backups[@]} )); then
    mv "${backups[@]}" "$OLD_DIR/"
    fi
    shopt -u nullglob

    # Download latest release
    "$HOME/scripts/github_latest_download.sh" \
        --rename "$appname" \
        "$github_url" \
        "$APP_DIR"

    # Ensure executable
    chmod +x "$APP_PATH"

    echo "Update complete: $APP_PATH"
}

update_github_app \
  "SQLite-Browser.AppImage" \
  "https://github.com/sqlitebrowser/sqlitebrowser/releases"

# SQLite-Browser
#sqlitebrowser='SQLite-Browser.AppImage'
#~/scripts/shell_common/backup.sh ~/apps/$sqlitebrowser
#mv ~/apps/$sqlitebrowser.*.bck ~/apps/OLD-VERSIONS/
#scripts/github_latest_download.sh --rename $sqlitebrowser https://github.com/sqlitebrowser/sqlitebrowser/releases ~/apps/
#chmod +x $HOME/apps/$sqlitebrowser

# Audacity
update_github_app \
  "Audacity.AppImage" \
  "https://github.com/audacity/audacity/releases"

# Balena Etcher
# TODO: the Linux version seems to be a zip file

# DigiKam
# Not Github https://invent.kde.org/graphics/digikam

# GeForce Now
update_github_app \
  "geforcenow-electron.AppImage" \
  "https://github.com/hmlendea/gfn-electron/releases"

# KDEnlive
# No releases on github? https://invent.kde.org/multimedia/kdenlive

# Nextcloud

# Unetbootin

# Microsoft Edit
# NOT WORKING
#update_github_app \
#  "edit" \
#  "https://github.com/microsoft/edit/releases"

# Tutanota
~/scripts/shell_common/get-tuta.sh &

