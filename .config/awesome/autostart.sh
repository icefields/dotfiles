#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

# run picom
run "$HOME/.config/awesome/screens.sh"
run "$HOME/.config/awesome/picom_delayed.sh"
run lxqt-policykit-agent
run blueman-applet
run nm-applet
run redshift-gtk
run xfce4-clipman
run xfce4-power-manager
run keepassxc
run "$HOME/.config/awesome/start_filemanager.sh"
run "$HOME/apps/Joplin/Joplin.AppImage"
run "$HOME/.config/awesome/start_nextcloud.sh"
run "$HOME/.config/awesome/start_tuta.sh"
$HOME/.config/awesome/autostart-custom.sh

