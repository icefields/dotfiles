sudo umount /etc/resolv.conf
sudo mount --bind /home/lucifer/.distrobox/resolv.conf /etc/resolv.conf
sudo umount /etc/hosts
sudo mount --bind /home/lucifer/.distrobox/hosts /etc/hosts -o rw,users,umask=0
