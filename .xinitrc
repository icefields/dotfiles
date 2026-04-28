xrdb -merge ~/.Xresources

# source .xprofile for ui env vars
[ -f ~/.xprofile ] && . ~/.xprofile

# Start systemd user X11 session bridge (IMPORTANT)
. /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

exec awesome > /tmp/awesome.log 2>&1 #exec dbus-run-session awesome

