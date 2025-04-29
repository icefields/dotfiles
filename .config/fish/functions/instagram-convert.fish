function instagram-convert
    set argc (count $argv)

    if test $argc -eq 3; and test $argv[1] = "-r"
        # Resize requested
        set resize_flag "-r"
        set input $argv[2]
        set output $argv[3]
    else if test $argc -eq 2
        # No resize
        set resize_flag ""
        set input $argv[1]
        set output $argv[2]
    else
        echo "Usage: instagram-convert [-r] input.mp4 output.mp4"
        return 1
    end

    bash ~/scripts/instagram-video-convert.sh $resize_flag $input $output
end

