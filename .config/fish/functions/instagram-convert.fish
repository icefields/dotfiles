function instagram-convert
    if test (count $argv) -ne 2
        echo "Usage: convert_to_h264 input.mp4 output.mp4"
        return 1
    end

    # Adjust path if your bash script lives elsewhere
    bash ~/scripts/instagram-video-convert.sh $argv[1] $argv[2]
end

