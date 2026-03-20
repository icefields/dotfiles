#!/bin/sh

run() {
    local cmd="$1"
    local pattern="$2"

    if ! pgrep -f "$pattern" > /dev/null; then
        nohup bash -c "$cmd" >/dev/null 2>&1 &
    else
        echo "application $2 running already"
    fi
}

run "flatpak run im.riot.Riot" "Riot"
# distrobox upgrade arch
# distrobox upgrade isol-arch
sleep 5

if [ -z "$(ls -A /mount/dir1)" ]; then
    sshfs -p 666 user@server.org:/remote/dir /mount/dir1
else
    echo "di1 not empty"
fi

sleep 5
run "distrobox upgrade --all" "distrobox"

