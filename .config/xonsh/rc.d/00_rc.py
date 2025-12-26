import os
import random
import sys
import platform
import subprocess
from xonsh.built_ins import XSH
from xonsh.xontribs import xontribs_load
import xontrib
import warnings
from pathlib import Path

# xontrib-kitty has some deprecations in the code
warnings.filterwarnings(
    "ignore",
    category=DeprecationWarning,
    module=r"xontrib_kitty.*",
)

# Enable full traceback of errors
logdir = Path.home() / '.xonsh-env'
# create log dir if not exists, comment out to just generate an error at startup.
# logdir.mkdir(parents=True, exist_ok=True)
__xonsh__.env['XONSH_SHOW_TRACEBACK'] = True
__xonsh__.env['XONSH_TRACEBACK_LOGFILE'] = str(logdir / 'xonsh_traceback.log')

# ------------------------------------------------------------
# Interactive guard
# ------------------------------------------------------------
if not XSH.env.get("XONSH_INTERACTIVE", False):
    pass
else:
    # --------------------------------------------------------
    # Helpers
    # --------------------------------------------------------
    def command_exists(cmd):
        return subprocess.call(
            ["which", cmd],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        ) == 0

    # empty CONTAINER_ID will return true
    def isDistrobox():
        return "CONTAINER_ID" in os.environ
    
    # empty CONTAINER_ID will return false
    # def is_distrobox():
    #     return bool(os.environ.get("CONTAINER_ID"))

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
    # Autosuggestions
    # --------------------------------------------------------
    # COMPLETION_MODE - How TAB completion behaves: 'default', 'menu-complete', 'reverse-menu-complete', 'readline'
    # UPDATE_COMPLETIONS_ON_KEYPRESS - Show completions automatically while typing (without TAB)
    # FUZZY_PATH_COMPLETION - Enable fallback fuzzy path matching
    # SUBSEQUENCE_PATH_COMPLETION - Allow matching subsequences in paths
    # XONSH_COMPLETIONS_DISPLAY - completion display style, override for PTK: 'single', 'multi', 'readline'
    # COMPLETIONS_DISPLAY - completion display style, same as XONSH_COMPLETIONS_DISPLAY
    # COMPLETIONS_MENU_ROWS - Number of rows visible in menu
    # COMPLETIONS_CONFIRM - Ask confirmation when many completions exist
    # PROMPT_TOOLKIT_COLOR_DEPTH - controls how many colors the terminal can use when xonsh is running under prompt_toolkit.
    # XONSH_HISTORY_MATCH_ANYWHERE - fish-like fuzzy autocomplete from history
    # UPDATE_PROMPT_ON_KEYPRESS - live update prompt on every keypress instead of only after hitting enter. This is a bit more resource intensive.
    # XONSH_AUTOPAIR - Whether Xonsh will auto-insert matching parentheses, brackets, and quotes (prompt-toolkit shell only)
    # CASE_SENSITIVE_COMPLETIONS - completions should be case sensitive or case insensitive
    # COMPLETION_IN_THREAD - controls whether tab completions run in a separate thread. If true the prompt will not freeze waiting for the auto-complete suggestion.
    __xonsh__.env['PROMPT_TOOLKIT_COLOR_DEPTH'] = 'DEPTH_24_BIT'
    __xonsh__.env['XONSH_AUTOSUGGESTION'] = 'prompt_toolkit' #'readline'
    __xonsh__.env['XONSH_COMPLETIONS_DISPLAY'] = 'multi'
    __xonsh__.env['COMPLETIONS_DISPLAY'] = 'multi'
    __xonsh__.env['XONSH_COMPLETIONS_IGNORE_CASE'] = True
    __xonsh__.env['XONSH_COMPLETIONS_MENU_COMPLETION'] = True
    __xonsh__.env['COMPLETION_MODE'] = 'menu-complete'
    __xonsh__.env['UPDATE_COMPLETIONS_ON_KEYPRESS'] = False
    __xonsh__.env['FUZZY_PATH_COMPLETION'] = True       # default True
    __xonsh__.env['SUBSEQUENCE_PATH_COMPLETION'] = True # default True
    __xonsh__.env['COMPLETIONS_MENU_ROWS'] = 6          # default 5
    __xonsh__.env['COMPLETIONS_CONFIRM'] = False        # default True
    __xonsh__.env['XONSH_HISTORY_MATCH_ANYWHERE'] = True
    __xonsh__.env['UPDATE_PROMPT_ON_KEYPRESS'] = True
    __xonsh__.env['XONSH_AUTOPAIR'] = True
    __xonsh__.env['CASE_SENSITIVE_COMPLETIONS'] = False
    __xonsh__.env['COMPLETION_IN_THREAD'] = True

    # Carapace auto-complete suggestions
    XSH.env["CARAPACE_BRIDGES"] = "zsh,fish,bash"  # inshellisense
    XSH.env["COMPLETIONS_CONFIRM"] = True
    # Execute carapace initialization
    exec(__xonsh__.subproc_captured_stdout(["carapace", "_carapace", "xonsh"]))

    # history settings
    # HISTCONTROL - ignoredups  will not save the command if it matches the previous command, erasedups  will remove all previous commands that matches and updates the frequency (only supported in sqlite)
    if isDistrobox():
        __xonsh__.env['XONSH_HISTORY_FILE'] = str(Path.home() / '.xonsh_history')
        __xonsh__.env['XONSH_HISTORY_SIZE'] = 10000
        __xonsh__.env['HISTCONTROL'] = 'ignoredups'
    else:
        __xonsh__.env['XONSH_HISTORY_FILE'] = str(Path.home() / '.xonsh_history.db')
        __xonsh__.env['XONSH_HISTORY_BACKEND'] = 'sqlite'
        __xonsh__.env['XONSH_HISTORY_SIZE'] = 100000
        __xonsh__.env['HISTCONTROL'] = 'erasedups'

 
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
    if command_exists("nvim"):
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
    
    __xonsh__.env['OS_NAME'] = OS_NAME

    # --------------------------------------------------------
    # Distrobox container handling
    # --------------------------------------------------------
    if isDistrobox():
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

