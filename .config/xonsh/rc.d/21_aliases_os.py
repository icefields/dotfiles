# --------------------------------------------------------
# OS-specific configuration
# --------------------------------------------------------

# Interactive guard
if not XSH.env.get("XONSH_INTERACTIVE", False):
    pass
else:    
    # simple: debUpdateCmd = "sudo apt update && sudo apt upgrade -y && sudo flatpak update --assumeyes && sudo apt autoremove -y"

    debUpdateCmd = (
        "sudo apt update && "
        "sudo apt upgrade -y && "
        # "sudo flatpak update --assumeyes && "
        "sudo apt autoremove -y"
    )

    archUpdateCmd = "yay -Syu --noconfirm"

    # if Distrobox installed, append "distrobox upgrade --all"
    if shutil.which("distrobox"):
        debUpdateCmd += " && distrobox upgrade --all"
        archUpdateCmd += " && distrobox upgrade --all"

    if shutil.which("flatpak"):
        debUpdateCmd += " && sudo flatpak update --assumeyes"
        archUpdateCmd += " && sudo flatpak update --assumeyes"


    if OS_NAME == "arch":
        abbrevs["ca"] = "bat --color=always"
        abbrevs["upd"] = archUpdateCmd
        aliases["cat"] = "bat -p --color=always"

        aliases.update({
            "pacsyu": "sudo pacman -Syu",
            "pacsyyu": "sudo pacman -Syyu",
            "parsua": "paru -Sua --noconfirm",
            "parsyu": "paru -Syu --noconfirm",
            "unlock": "sudo rm /var/lib/pacman/db.lck",
            "orphan": "sudo pacman -Rns $(pacman -Qtdq)",
            "mirror": "sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist",
            "mirrord": "sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist",
            "mirrors": "sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist",
            "mirrora": "sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist",
        })

    elif OS_NAME == "ubuntu":
        abbrevs["ca"] = "batcat --color=always"
        abbrevs["upd"] = debUpdateCmd        
        aliases["cat"] = "batcat -p --color=always"

    elif OS_NAME == "fedora":
        abbrevs["vi"] = "nvim"
        abbrevs["upd"] = "sudo dnf upgrade"

        # TODO: FIX: hack to autostart Hyprland
        try:
            if os.ttyname(sys.stdin.fileno()) == "/dev/tty1":
                os.execvp("Hyprland", ["Hyprland"])
        except Exception:
            pass

    elif OS_NAME == "macos":
        abbrevs["ca"] = "bat --color=always"
        aliases["cat"] = "bat -p --color=always"

    elif OS_NAME == "linuxmint":
        abbrevs["ca"] = "batcat --color=always"
        abbrevs["upd"] = debUpdateCmd
        aliases["cat"] = "batcat -p --color=always"

    else:
        print("CANNOT DETECT OS, CHECK xonshrc.py FILE")

