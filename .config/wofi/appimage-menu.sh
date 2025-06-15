#!/bin/bash

# Path to directory containing .AppImage files.
DIR="$HOME/apps"
TYPE="" #".AppImage"

# Generate wofi compatible list from .AppImage files in specified directory.
find "$DIR" -maxdepth 1 -type f -name "*$TYPE" | while read -r appimage; do
    basename=$(basename "$appimage")
    echo "${basename}"
done | wofi --dmenu -i -p "Select Application:" | while IFS= read -r selected_basename; do

  # Find the full path of the selected .AppImage
  appimage_path=$(find "$DIR" -maxdepth 1 -type f -name "${selected_basename}")

  if [[ -f "$appimage_path" ]]; then
      chmod +x "$appimage_path"
      "$appimage_path"
  else
      echo "File not found: $appimage_path"
  fi
done

