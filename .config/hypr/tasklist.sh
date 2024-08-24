hyprctl clients | rg ^Window | sed -e 's/.*-> //' -e 's/ Window.*//' -e 's/:$//' |  awk -F' — ' '{
    if (NF > 1) {
      # Handle em dash
      n = split($0, a, " — ")
      for (i=n; i>1; i--) printf "%s — ", a[i]
      print a[1]
    } else {
      # Handle double dash or single dash
      n = split($0, a, " -- ")
      if (n <= 1) {
        n = split($0, a, " - ")
        for (i=n; i>1; i--) printf "%s - ", a[i]
        print a[1]
      } else {
        for (i=n; i>1; i--) printf "%s -- ", a[i]
        print a[1]
      }
    }
  }' | wofi --dmenu | awk '{print $2}' | xargs -I{} hyprctl dispatcher focuswindow "address:0x{}"

