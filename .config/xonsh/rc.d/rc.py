import os
import sys
import platform
import subprocess
from xonsh.built_ins import XSH
from xonsh.xontribs import xontribs_load
import xontrib
import warnings

# xontrib-kitty has some deprecations in the code
warnings.filterwarnings(
    "ignore",
    category=DeprecationWarning,
    module=r"xontrib_kitty.*",
)

# ------------------------------------------------------------
# Interactive guard
# ------------------------------------------------------------
if not XSH.env.get("XONSH_INTERACTIVE", False):
    pass
else:
    # --------------------------------------------------------
    # Load xontribs
    # --------------------------------------------------------
    xontribs_load(["abbrevs"])
    abbrevs = XSH.ctx["abbrevs"]
    aliases = XSH.aliases
    xontribs_load(["fish_completer"])
    xontribs_load(["kitty"])
    #__xonsh__.execer.exec("xontrib load fish_completer")

    # --------------------------------------------------------
    # Helpers
    # --------------------------------------------------------
    def command_exists(cmd):
        return subprocess.call(
            ["which", cmd],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        ) == 0

    # Enable autosuggestions
    __xonsh__.env['XONSH_AUTOSUGGESTION'] = 'prompt_toolkit' #'readline'
    __xonsh__.env['XONSH_COMPLETIONS_DISPLAY'] = 'multi'
    __xonsh__.env['XONSH_COMPLETIONS_IGNORE_CASE'] = True
    __xonsh__.env['XONSH_COMPLETIONS_MENU_COMPLETION'] = True

    # Carapace auto-complete suggestions
    XSH.env["CARAPACE_BRIDGES"] = "zsh,fish,bash"  # inshellisense
    XSH.env["COMPLETIONS_CONFIRM"] = True
    # Execute carapace initialization
    exec(__xonsh__.subproc_captured_stdout(["carapace", "_carapace", "xonsh"]))

    # history settings
    __xonsh__.env['XONSH_HISTORY_FILE'] = '.xonsh_history'
    __xonsh__.env['XONSH_HISTORY_SIZE'] = 10000
    __xonsh__.env['HISTCONTROL'] = 'ignoredups'

    # theme
    __xonsh__.env['XONSH_COLOR_STYLE'] = 'nord-darker'


    scriptsDir = os.path.expanduser("~/scripts/shell_common")

    # --------------------------------------------------------
    # Greeting
    # --------------------------------------------------------
    #subprocess.run(["lua", os.path.join(scriptsDir, "luci_greeting.lua")])
    subprocess.run([os.path.join(scriptsDir, "luci_greeting.sh")])
    subprocess.run(["lua", os.path.join(scriptsDir, "shell_greeting.lua")])
 
    # --------------------------------------------------------
    # Environment variables
    # --------------------------------------------------------
    XSH.env["EDITOR"] = "nvim"
    XSH.env["MANPAGER"] = "nvim +Man!"
 
    # --------------------------------------------------------
    # Abbreviations — Git
    # --------------------------------------------------------
    abbrevs.update({
        "ad": "git add .",
        "pus": "git push -u origin",
        "pum": "git push -u origin main",
        "pud": "git push -u origin dev",
        "com": "git commit -m ",
        "chb": "git checkout -b",
        "che": "git checkout",
        "pul": "git pull",
    })

    # --------------------------------------------------------
    # Abbreviations — gitdots
    # --------------------------------------------------------
    abbrevs.update({
        "dad": "gitdots add",
        "dstatus": "gitdots status",
        "ddiff": "gitdots diff",
        "dcom": "gitdots commit -m ",
        "dpus": "gitdots push -u origin main",
    })

    # --------------------------------------------------------
    # Abbreviations — cp replacement
    # --------------------------------------------------------
    abbrevs.update({
        "cpup": "rsync --progress -auv",
        "cp": "rsync --progress -av",
    })

    # --------------------------------------------------------
    # Aliases — grep
    # --------------------------------------------------------
    aliases.update({
        "grep": "grep --color=auto",
        "egrep": "egrep --color=auto",
        "fgrep": "fgrep --color=auto",
    })

    # --------------------------------------------------------
    # Navigation
    # --------------------------------------------------------
    aliases[".."] = "cd .."

    # --------------------------------------------------------
    # journalctl
    # --------------------------------------------------------
    aliases["jctl"] = "journalctl -p 3 -xb"

    # --------------------------------------------------------
    # GPG
    # --------------------------------------------------------
    aliases.update({
        "gpg-check": "gpg2 --keyserver-options auto-key-retrieve --verify",
        "gpg-retrieve": "gpg2 --keyserver-options auto-key-retrieve --receive-keys",
    })

    # --------------------------------------------------------
    # Git aliases (non-abbrev)
    # --------------------------------------------------------
    aliases.update({
        "addup": "git add -u",
        "addall": "git add .",
        "branch": "git branch",
        "checkout": "git checkout",
        "clone": "git clone",
        "commit": "git commit -m",
        "fetch": "git fetch",
        "pull": "git pull",
        "push": "git push -u origin",
        "tag": "git tag",
        "newtag": "git tag -a",
    })

    # --------------------------------------------------------
    # ps helpers
    # --------------------------------------------------------
    aliases.update({
        "psa": "ps auxf",
        "psgrep": "ps aux | grep -v grep | grep -i -e VSZ -e",
        "psmem": "ps auxf | sort -nr -k 4",
        "pscpu": "ps auxf | sort -nr -k 3",
    })

    # --------------------------------------------------------
    # Misc aliases
    # --------------------------------------------------------
    aliases.update({
        ":q": "exit",
        "toreset": f"{os.environ['HOME']}/scripts/tor_relay_reset.sh",
        "toripify": "torsocks wget -qO - https://api.ipify.org; echo",
        "rebootToMac": "sudo sh -c 'echo 1 | asahi-bless; reboot'",
        "df": "df -h",
        "free": "free -m",
    })

    # --------------------------------------------------------
    # Dotfiles bare repo
    # --------------------------------------------------------
    aliases["gitdots"] = (
        f"/usr/bin/git --git-dir={os.environ['HOME']}/.git-dotfiles/ "
        f"--work-tree={os.environ['HOME']}"
    )

    # --------------------------------------------------------
    # vim → nvim fallback
    # --------------------------------------------------------
    if not command_exists("vim") and command_exists("nvim"):
        aliases["vim"] = "nvim"

    # --------------------------------------------------------
    # ls / tree (eza / exa)
    # --------------------------------------------------------
    if command_exists("eza"):
        aliases.update({
            "ls": "eza -a --color=always --group-directories-first --icons=always --mounts --git --git-repos",
            "tree": "eza -alh@ --color=always --group-directories-first --tree --level",
        })
        abbrevs["l"] = "eza -al --color=always --group-directories-first --icons=always --mounts --git --git-repos"

    elif command_exists("exa"):
        aliases.update({
            "ls": "exa -a --color=always --group-directories-first --icons",
            "tree": "exa -alh@ --color=always --group-directories-first --tree --level",
        })
        abbrevs["l"] = "exa -al --color=always --group-directories-first --icons"

    # --------------------------------------------------------
    # OS detection
    # --------------------------------------------------------
    system = platform.system()

    if system == "Darwin":
        OS_NAME = subprocess.check_output(
            ["sw_vers", "-productName"], text=True
        ).strip()
    else:
        try:
            OS_NAME = subprocess.check_output(
                ["lsb_release", "-is"], text=True
            ).strip()
        except Exception:
            OS_NAME = system

    # --------------------------------------------------------
    # Distrobox container handling
    # --------------------------------------------------------
    if os.environ.get("CONTAINER_ID"):
        XSH.env.pop("SESSION_MANAGER", None)
        if os.getcwd() != os.environ["HOME"]:
            os.chdir(os.environ["HOME"])

    # --------------------------------------------------------
    # OS-specific configuration
    # --------------------------------------------------------
    if OS_NAME == "Arch":
        abbrevs["ca"] = "bat --color=always"
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

    elif OS_NAME == "Ubuntu":
        abbrevs["ca"] = "batcat --color=always"
        abbrevs["upd"] = "sudo apt update && sudo apt upgrade -y"
        aliases["cat"] = "batcat -p --color=always"

    elif OS_NAME == "Fedora":
        abbrevs["vi"] = "nvim"
        abbrevs["upd"] = "sudo dnf upgrade"
        aliases["dmenu"] = "wofi --dmenu"

        try:
            if os.ttyname(sys.stdin.fileno()) == "/dev/tty1":
                os.execvp("Hyprland", ["Hyprland"])
        except Exception:
            pass

    elif OS_NAME == "macOS":
        abbrevs["ca"] = "bat --color=always"
        aliases["cat"] = "bat -p --color=always"

    elif OS_NAME == "Linuxmint":
        abbrevs["ca"] = "batcat --color=always"
        abbrevs["upd"] = "sudo apt update && sudo apt upgrade -y"
        aliases["cat"] = "batcat -p --color=always"

    else:
        print("CANNOT DETECT OS, CHECK xonshrc.py FILE")
 
