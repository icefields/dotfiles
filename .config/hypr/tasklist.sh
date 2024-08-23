hyprctl clients | rg ^Window | wofi --dmenu | awk '{print $2}' | xargs -I{} hyprctl dispatcher focuswindow "address:0x{}"

