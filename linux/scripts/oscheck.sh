echo "Kernel"
uname -r
echo "\nRelease info"
lsb_release -a

osName=$(lsb_release -is)
# how many packages installed
echo "\nPackages installed"
case "$osName" in
  "Arch")
      pacman -Qq | wc -l
    ;;
  "Linuxmint")
    apt list --installed | wc -l
    ;;
  "Fedora")
    dnf list installed | wc -l
    ;;
  *)
    echo "Unknown OS"
    ;;
esac

echo "\nLua"
whereis lua
echo "\nPipewire"
whereis pipewire
echo "\nSnap"
whereis snapd
echo "\nFlatpak"
whereis flatpak

echo "\nSession Type"
echo $XDG_SESSION_TYPE

echo "\nShell"
echo $SHELL

cat /etc/passwd | grep luci

echo "\n\n\n"

lsblk -f
echo "\n-----------------------------------------------\n"
lsblk

# printenv
