function xclip
    if test "$XDG_SESSION_TYPE" = "wayland"
        wl-copy
    else
        command xclip $argv
    end

end

