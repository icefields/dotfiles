#!/bin/bash
btrfs filesystem df /mnt/hd1
sudo btrfs device stats /mnt/hd1
sudo fstrim /mnt/hd1

#**Schedule the Script with systemd:**
#Create a systemd service and timer to run the script regularly.
#
#- **Create the Service File:**
#   sudo vim /etc/systemd/system/btrfs-trim.service
#
#   Add the following:
#
#     [Unit]
#     Description=Run Btrfs TRIM
#
#     [Service]
#     Type=oneshot
#     ExecStart=/home/lucifer/scripts/btrfs-trim.sh
#
#- **Create the Timer File:**
#     sudo vim /etc/systemd/system/btrfs-trim.timer
#
#   Add the following:
#
#     [Unit]
#     Description=Run Btrfs TRIM weekly
#
#     [Timer]
#     OnCalendar=weekly
#     Persistent=true
#
#     [Install]
#     WantedBy=timers.target
#
#**Enable and Start the Timer:**
#
#   sudo systemctl enable btrfs-trim.timer
#   sudo systemctl start btrfs-trim.timer

