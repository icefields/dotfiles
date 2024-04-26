#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

# run picom
run "/home/lucifer/.config/awesome/screens.sh"
run "/home/lucifer/.config/awesome/picom_delayed.sh"
run blueman-applet
run nm-applet
run redshift-gtk
run xfce4-power-manager
run keepassxc
run nemo
run "/home/lucifer/apps/Joplin/Joplin-2.12.18.AppImage"
run "/home/lucifer/.config/awesome/start_nextcloud.sh"
run "/home/lucifer/.config/awesome/start_tuta.sh"
