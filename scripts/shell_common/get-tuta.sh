#!/usr/bin/env bash

curl -L -o $HOME/apps/tutanota-desktop-linux.AppImage https://app.tuta.com/desktop/tutanota-desktop-linux.AppImage
# wget --output-document $HOME/apps/tutanota-desktop-linux.AppImage https://app.tuta.com/desktop/tutanota-desktop-linux.AppImage
chmod +x $HOME/apps/tutanota-desktop-linux.AppImage
$HOME/scripts/wm_common/start_tuta.sh &
rm $HOME/.cache/tutanota-desktop-updater/pending/*

