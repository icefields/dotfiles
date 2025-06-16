#!/bin/bash

shader_val=$(hyprctl getoption decoration:screen_shader -j | jq -r '.str')

if [ -z "$shader_val" ] || [ "$shader_val" = "[[EMPTY]]" ]; then
    $HOME/.config/hypr/redfilter-start.sh
    echo "Shader is empty"
else
    $HOME/.config/hypr/redfilter-stop.sh
    echo "Shader is set to: $shader_val"
fi

