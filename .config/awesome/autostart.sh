#!/bin/sh

run() {
  if ! pgrep -f "$1" ;
  then
    "$@"&
  fi
}

run "$HOME/.config/awesome/scripts/screens.sh"
run "$HOME/.config/awesome/scripts/picom_delayed.sh"
#sleep 5
run lxqt-policykit-agent
run keepassxc
#run blueman-applet
run nm-applet
run xfce4-clipman
run "$HOME/scripts/wm_common/power-management.sh" # "xfce4-power-manager --daemon --no-tray-icon" #xfce4-power-manager
run "$HOME/scripts/wm_common/start_filemanager.sh"

sleep 3
run "$HOME/apps/Joplin/Joplin.AppImage"
run "$HOME/scripts/wm_common/start_nextcloud.sh"
run "$HOME/scripts/wm_common/start_tuta.sh"
$HOME/.config/awesome/autostart-custom.sh &

sleep 5
if ! pgrep -x "redshift" > /dev/null
then
    : # run redshift #run redshift-gtk
fi
