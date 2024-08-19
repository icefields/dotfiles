#!/bin/bash

# Directory containing the wallpapers
DIRECTORY="$HOME/Pictures/wallpapers"
cd "$DIRECTORY" || { echo "Directory not found"; exit 1; }

# Check if the directory is empty
if [ -z "$(ls -A "$DIRECTORY")" ]; then
  echo "No files found in the directory"
  exit 1
fi

# Pick 3 random wallpapers
FILE0=$(ls | shuf -n 1)
FILE1=$(ls | shuf -n 1)
FILE2=$(ls | shuf -n 1)

# Rename the chosen files to wall0.png, wall1.png and wall2.png
# corresponding links to those 3 files have to be present in
# /usr/share/hyprland/ 
# in order for hyprland to pick them up and set the random wallpaper.
rm wall0.png
rm wall1.png
rm wall2.png
cp "$FILE0" "wall0.png"
cp "$FILE1" "wall1.png"
cp "$FILE2" "wall2.png"
