#!/usr/bin/env bash
set -euo pipefail

#######################################
# Defaults
#######################################
DRY_RUN=false
LIST_ASSETS=false
RENAME=""
SCRIPT_NAME=$(basename "$0")

#######################################
# Help
#######################################
show_help() {
  cat <<EOF
Usage:
  $SCRIPT_NAME [OPTIONS] <github_releases_url> <destination_directory>

Options:
  --dry-run            Show what would be downloaded, but do nothing
  --list-assets        List all assets in the latest release and exit
  --rename NAME        Rename downloaded file to NAME
  --help               Show this help message

Asset selection priority (Linux):
  1. AppImage
  2. Flatpak
  3. Other Linux binaries (.tar.*, .bin, .run)

Examples:
  $SCRIPT_NAME https://github.com/sqlitebrowser/sqlitebrowser/releases ~/Downloads
  $SCRIPT_NAME --dry-run --rename dbbrowser.AppImage \\
    https://github.com/sqlitebrowser/sqlitebrowser/releases ~/.local/bin
  $SCRIPT_NAME --list-assets https://github.com/sqlitebrowser/sqlitebrowser/releases /tmp
EOF
}

#######################################
# Argument parsing
#######################################
ARGS=()

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --list-assets)
      LIST_ASSETS=true
      shift
      ;;
    --rename)
      [ $# -lt 2 ] && { echo "Error: --rename requires a value"; show_help; exit 1; }
      RENAME="$2"
      shift 2
      ;;
    --help|-h)
      show_help
      exit 0
      ;;
    -*)
      echo "Unknown option: $1"
      show_help
      exit 1
      ;;
    *)
      ARGS+=("$1")
      shift
      ;;
  esac
done


if $LIST_ASSETS; then
  [ "${#ARGS[@]}" -ne 1 ] && {
    echo "Error: --list-assets requires only <github_releases_url>"
    show_help
    exit 1
  }
else
  [ "${#ARGS[@]}" -ne 2 ] && {
    echo "Error: Missing required arguments"
    show_help
    exit 1
  }
fi

RELEASES_URL="${ARGS[0]}"
DEST_DIR="${ARGS[1]:-}"

#######################################
# Validate GitHub URL
#######################################
if [[ ! "$RELEASES_URL" =~ github.com/([^/]+)/([^/]+)/releases ]]; then
  echo "Error: Invalid GitHub releases URL"
  show_help
  exit 1
fi

OWNER="${BASH_REMATCH[1]}"
REPO="${BASH_REMATCH[2]}"

API_URL="https://api.github.com/repos/$OWNER/$REPO/releases/latest"

#######################################
# Fetch release data
#######################################
JSON=$(curl -s "$API_URL")

#######################################
# List assets
#######################################
if $LIST_ASSETS; then
  echo "Assets in latest release of $OWNER/$REPO:"
  echo "$JSON" | grep browser_download_url | cut -d '"' -f 4
  exit 0
fi

#######################################
# Asset selection (Linux priority)
#######################################
select_asset() {
  echo "$JSON" | grep browser_download_url | grep -i "$1" | head -n 1 | cut -d '"' -f 4
}

ASSET_URL=$(select_asset appimage)

[ -z "$ASSET_URL" ] && ASSET_URL=$(select_asset flatpak)
[ -z "$ASSET_URL" ] && ASSET_URL=$(
  echo "$JSON" | grep browser_download_url | grep -Ei 'linux|\.tar\.|\.bin|\.run' |
  head -n 1 | cut -d '"' -f 4
)

if [ -z "$ASSET_URL" ]; then
  echo "Error: No suitable Linux asset found"
  exit 1
fi

#######################################
# Filename handling
#######################################
ORIGINAL_NAME=$(basename "$ASSET_URL")
FINAL_NAME="${RENAME:-$ORIGINAL_NAME}"
TARGET_PATH="$DEST_DIR/$FINAL_NAME"

#######################################
# Dry run
#######################################
if $DRY_RUN; then
  echo "Dry run:"
  echo "  Repo:        $OWNER/$REPO"
  echo "  Asset URL:   $ASSET_URL"
  echo "  Destination $TARGET_PATH"
  exit 0
fi

#######################################
# Download
#######################################
mkdir -p "$DEST_DIR"

echo "Downloading:"
echo "  $ASSET_URL"
echo "→ $TARGET_PATH"

curl -L "$ASSET_URL" -o "$TARGET_PATH"
chmod +x "$TARGET_PATH" 2>/dev/null || true
#if curl -fL -z "$TARGET_PATH" "$ASSET_URL" -o "$TARGET_PATH"; then
#    echo "Up to date or downloaded successfully"
#    chmod +x "$TARGET_PATH" 2>/dev/null || true
#else
#    echo "Not Downloaded, existing file already newer version"
#    exit 1
#fi

echo "Done."

