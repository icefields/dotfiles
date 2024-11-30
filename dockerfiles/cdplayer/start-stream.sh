#!/bin/bash

ln -s /dev/sr0 /dev/cdrom

# Set the device path (adjust as needed)
CDROM_DEVICE="/dev/cdrom"

# Check if the CD device exists
if [ ! -e "$CDROM_DEVICE" ]; then
  echo "Error: CD device $CDROM_DEVICE does not exist."
  exit 1
fi

# Start streaming
echo "Starting CD streaming from $CDROM_DEVICE..."

#cdtool play
#mplayer cdda://
# mplayer -cdrom-device "$CDROM_DEVICE" cdda:// -ao pcm - | ffmpeg -f s16le -ar 44.1k -ac 2 -i - -f mpegts http://localhost:8888

