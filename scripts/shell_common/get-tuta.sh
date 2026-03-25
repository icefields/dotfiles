#!/usr/bin/env bash

wget --output-document $HOME/apps/tutanota-desktop-linux.AppImage https://app.tuta.com/desktop/tutanota-desktop-linux.AppImage
chmod +x $HOME/apps/tutanota-desktop-linux.AppImage
$HOME/.config/awesome/scripts/start_tuta.sh &
rm $HOME/.cache/tutanota-desktop-updater/pending/*

