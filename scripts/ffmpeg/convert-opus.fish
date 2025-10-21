#!/usr/bin/env fish

########################################################################################################
# | Argument                              | Notes                                                     |
# | ------------------------------------- | --------------------------------------------------------- |
# | `-i "$f"`                             | Input file                                                |
# | `-vn`                                 | Ignores any embedded video/artwork                        |
# | `-c:a libopus`                        | Uses Opus codec                                           |
# | `-application audio`                  | Tuned for general audio/music (vs. `voip`)                |
# | `-b:a 128k`                           | Bitrate. 128k: balance of quality and file size for music |
# | `-compression_level 10`               | Maximizes compression efficiency with no quality loss     |
# | `-vbr on`                             | (Default) Enables variable bitrate                        |
# | `-f ogg`                              | (Default) container for .opus files                       |
# | `"/home/user/Music/OPUS/".$base.opus` | Defined output path                                       |
#########################################################################################################

if test -n "$argv[1]"
    set convkbps $argv[1]
else
    set convkbps 192
end

if test -n "$argv[2]"
    set convpath $argv[2]
else
    set convpath $HOME/Music/opusflat
end

echo "kbps: $convkbps"
echo "path: $convpath"

# Abort if values are suspicious
if test -z "$convkbps" -o -z "$convpath"
    echo "Error: missing bitrate or path"
    exit 1
end

mkdir -p "$convpath"
for f in *.mp3 *.flac *.wav
    if test -f "$f"
        set ext (string split -r . "$f")[-1]
        set base (string replace -r "\.$ext\$" "" "$f")
        ffmpeg -i "$f" -vn -c:a libopus -application audio -b:a "$convkbps"k -compression_level 10 -vbr on -f ogg "$convpath/$base".opus
    end
end

