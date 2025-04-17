#!/bin/bash

# Check if correct number of arguments are provided
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 input.mp4 output.mp4"
  exit 1
fi

# Assign arguments to variables
INPUT="$1"
OUTPUT="$2"

# Run the ffmpeg command
ffmpeg -i "$INPUT" -c:v libx264 -b:v 3500k -maxrate 3500k -bufsize 7000k \
  -c:a aac -b:a 128k -pix_fmt yuv420p -preset fast "$OUTPUT"

