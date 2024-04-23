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
run "/home/lucifer/apps/Nextcloud-3.12.3-x86_64.AppImage --background"
# autostart tutanota in background
run "/home/lucifer/apps/tutanota-desktop-linux.AppImage -a"
