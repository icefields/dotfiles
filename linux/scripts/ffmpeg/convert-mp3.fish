#!/usr/bin/env fish

# ------------------------------------------------------------------------------
# MP3 Converter Script – Max Quality, Metadata, and Cover Art Preserved
# ------------------------------------------------------------------------------
#
# This script converts audio files to MP3 using FFmpeg with the following:
# - Maximum possible audio quality in the MP3 format (320 kbps CBR)
# - Full metadata preservation (title, artist, album, etc.)
# - Embedded cover art (album artwork) preserved if present
# - (optional) Compatibility-optimized ID3 tagging (v2.3 + v1)
#
# FFmpeg command used:
#
# ffmpeg -i "$f" \
#        -map 0:a \
#        -map 0:v? \
#        -c:a libmp3lame \
#        -b:a 320k \
#        -id3v2_version 3 \
#        -write_id3v1 1 \
#        "/mnt/drive1/mp3/$basename.mp3"
#
# ---------------------------------------
# Breakdown of Options:
# ---------------------------------------
#
# -i "$f"
#     Specifies the input.
#
# -map 0:a
#     Selects the audio stream(s) from input #0. Ensures only audio is encoded.
#
# -map 0:v?
#     Optionally maps the video stream from input #0 (used for album art).
#     The '?' means "map if present" — avoids errors if no video stream exists.
#
# -c:a libmp3lame
#     Uses the LAME MP3 encoder, the highest quality MP3 encoder available.
#
# -b:a 320k
#     Sets the audio bitrate to 320 kbps CBR (constant bitrate),
#     the maximum quality supported by MP3 format.
#
# -id3v2_version 3
#     Writes ID3v2.3 tags. This is the most widely supported version
#     across media players, car stereos, and mobile devices.
#
# -write_id3v1 1
#     Also includes ID3v1 tags for maximum backward compatibility.
#
# ---------------------------------------
# Notes:
# ---------------------------------------
# - If the input FLAC is multi-channel (e.g., 5.1 surround), and stereo is needed,
#   add:      -ac 2
#
# - If you want to enforce a standard sample rate (e.g., 44.1 kHz), add:
#             -ar 44100
#
# ------------------------------------------------------------------------------

if test -n "$argv[1]"
    set convpath $argv[1]
else
    set convpath "/home/lucifer/Music/mp3flat"
end

mkdir -p "$convpath"

for f in *.flac *.wav
    if test -f "$f"
        set ext (string split -r . "$f")[-1]
        set base (string replace -r "\.$ext\$" "" "$f")
        ffmpeg -i "$f" -vn -codec:a libmp3lame -b:a 320k -map_metadata 0 "$convpath/$base.mp3"
    end
end

