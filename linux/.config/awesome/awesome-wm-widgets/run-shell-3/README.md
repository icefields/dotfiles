# Run Shell

This widget blurs/pixelates the background and shows a run prompt:

![screenshot](./blur.png)

![screenshot](./pixelate.png)

## Installation

1. To blur/pixelate the background, this widget uses [ffmpeg](https://www.ffmpeg.org/) and [frei0r](https://frei0r.dyne.org/) plugins (if you want to pixelate the background), which you need to install. Installation depends on your distribution. For ffmpeg, follow the installation section of the site. For frei0r, you can install it by running:

    ```
    sudo apt-get install frei0r-plugins
    ```

1. Clone this repo under **~/.config/awesome/**:

    ```bash
    git clone https://github.com/streetturtle/awesome-wm-widgets.git ~/.config/awesome/awesome-wm-widgets
    ```

1. Require widget at the beginning of **rc.lua**:

    ```lua
    local run_shell = require("awesome-wm-widgets.run-shell-3.run-shell")
    ```

1. Use it (don't forget to comment out the default prompt):

    ```lua
    awful.key({modkey}, "r", function () run_shell.launch() end),
    ```

**Warning:** This widget may have a memory leak. If awesome uses lots of RAM, reload the config (Ctrl + Mod4 + r).
