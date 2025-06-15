#!/bin/bash

if [ -f $HOME/.config/pipewire/pipewire.conf.d/normal.conf ]; then
    echo "  "
elif [ -f $HOME/.config/pipewire/pipewire.conf.d/lowlatency.conf ]; then
    echo "🎸 "
else
    echo "⚠️ "
fi

