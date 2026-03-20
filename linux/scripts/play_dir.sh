#!/bin/bash

# Check if the random option (-r or --random) is provided
if [[ "$1" == "-r" || "$1" == "--random" ]]; then
  RANDOMIZE=true
  shift  # Remove the random option from the arguments
else
  RANDOMIZE=false
fi

# If no argument for directory is provided, default to the current directory
ARG_DIR="${1:-$(pwd)}"

# Choose the appropriate sorting method based on the randomization flag
if [ "$RANDOMIZE" = true ]; then
  find "$ARG_DIR" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" \) -print0 | shuf -z | xargs -0 mpv --no-loop
else
  find "$ARG_DIR" -type f \( -iname "*.mp3" -o -iname "*.flac" -o -iname "*.wav" \) -print0 | sort -V -z | xargs -0 mpv --no-loop
fi

# Play using a playlist
# find /path/to/directory -type f -iname "*.mp3" | sort > playlist.txt
# mpv --playlist=playlist.txt

