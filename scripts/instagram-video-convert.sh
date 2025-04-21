#!/bin/bash
RESIZE=false
ARGS=()

for arg in "$@"; do
  if [ "$arg" = "-r" ]; then
    RESIZE=true
  elif [[ -z "${arg//[[:space:]]/}" ]]; then
    # Skip empty or whitespace-only args
    continue
  else
    ARGS+=("$arg")
  fi
done

echo "${ARGS[0]}"

# Get input and output from remaining args
if [ "${#ARGS[@]}" -ne 2 ]; then
  echo "Usage: $0 [-r] input.mp4 output.mp4"
  exit 1
fi

INPUT="${ARGS[0]}"
OUTPUT="${ARGS[1]}"

VF_FLAG="-vf"
VF_EXPR="null"

CMD=(ffmpeg -i "$INPUT")

# Apply resize filter if -r was passed
if [ "$RESIZE" = true ]; then
    read WIDTH HEIGHT <<< $(ffprobe -v error -select_streams v:0 \
        -show_entries stream=width,height -of csv=p=0:s=x "$INPUT" | tr 'x' ' ')

    echo "Input resolution: ${WIDTH}x${HEIGHT}"
    VF_EXPR="scale='if(gt(iw,ih),720,-2)':'if(gt(iw,ih),-2,720)'"
fi


# Get frame rate as float (e.g. 29.97, 60.00)
FPS_RAW=$(ffprobe -v 0 -select_streams v:0 -show_entries stream=r_frame_rate \
  -of csv=p=0 "$INPUT")
FPS=$(echo "scale=2; $FPS_RAW" | bc)

# Decide whether to force -r 30 or keep original
FPS_OPTION=""
if [[ "$FPS" != "23.98" && "$FPS" != "24.00" && "$FPS" != "29.97" && "$FPS" != "30.00" && "$FPS" != "59.94" && "$FPS" != "60.00" ]]; then
  FPS_OPTION="-r 30"
fi

# Get input resolution (width x height)

ffmpeg -i "$INPUT" \
    $VF_FLAG "$VF_EXPR" \
    $FPS_OPTION \
    -c:v libx264 -crf 18 -preset slow \
    -c:a aac -b:a 192k -movflags +faststart \
    -pix_fmt yuv420p \
    -stats -loglevel warning "$OUTPUT"

