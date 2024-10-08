#!/bin/bash
btrfs filesystem df /mnt/hd1
sudo btrfs device stats /mnt/hd1
sudo fstrim /mnt/hd1

#**Schedule the Script with systemd:**
#   Create a systemd service and timer to run the script regularly.
#
#   - **Create the Service File:**
#
#     ```bash
#     sudo vim /etc/systemd/system/btrfs-trim.service
#     ```
#
#     Add the following:
#
#     ```ini
#     [Unit]
#     Description=Run Btrfs TRIM
#
#     [Service]
#     Type=oneshot
#     ExecStart=/usr/local/bin/btrfs-trim.sh
#     ```
#
#   - **Create the Timer File:**
#
#     ```bash
#     sudo vim /etc/systemd/system/btrfs-trim.timer
#     ```
#
#     Add the following:
#
#     ```ini
#     [Unit]
#     Description=Run Btrfs TRIM weekly
#
#     [Timer]
#     OnCalendar=weekly
#     Persistent=true
#
#     [Install]
#     WantedBy=timers.target
#     ```

#6. **Enable and Start the Timer:**
#
#   ```bash
#   sudo systemctl enable btrfs-trim.timer
#   sudo systemctl start btrfs-trim.timer
#   ```

