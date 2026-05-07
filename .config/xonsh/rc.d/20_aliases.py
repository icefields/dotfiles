# --- aliases for both interactive and non interactive shell
aliases["backup"] = str(Paths.SHELL_COMMON_SCRIPTS_DIR / 'backup.sh')
aliases["share"] = str(Paths.SCRIPTS_DIR / 'share.sh --ntfy -p')
aliases["sharesec"] = str(Paths.SCRIPTS_DIR / 'share.sh --ntfy --secret -p')
aliases["sharemega"] = str(Paths.SCRIPTS_DIR / 'share.sh -m --ntfy --secret -p')
aliases["passgen"] = str(Paths.SHELL_COMMON_SCRIPTS_DIR / 'passgen_wrapper.sh')
aliases["unzip"] = str(Paths.SHELL_COMMON_SCRIPTS_DIR / 'unzip.sh')
aliases["reaper"] = str(Paths.WM_COMMON_SCRIPTS_DIR / 'start_reaper.sh')

aliases.update({
    "rebootToMac": "sudo sh -c 'echo 1 | asahi-bless; reboot'",
    "toreset": str(Paths.SCRIPTS_DIR / 'tor_relay_reset.sh'), #f"{os.environ['HOME']}/scripts/tor_relay_reset.sh",
    "toripify": "torsocks wget -qO - https://api.ipify.org; echo",
})

# --------------------------------------------------------
# midorifetch
# --------------------------------------------------------
aliases["midorifetch"] = 'lua ' + str(Paths.HOME / 'scripts/shell_common/midori-fetch/midorifetch.lua')

# --------------------------------------------------------
# vim → nvim fallback
# --------------------------------------------------------
if commandExists("nvim"):
    aliases["vim"] = "nvim"


# Interactive guard
if not XSH.env.get("XONSH_INTERACTIVE", False):
    # aliases specific to non interactive shell
    pass
else:
    # aliases specific to interactive shell
    
    aliases["getpath"] = "find -type f | fzf | sed 's/^..//' | tr -d '\\n' | xclip -selection c"
    
    # --------------------------------------------------------
    # archives
    # --------------------------------------------------------
    aliases["tari"] = str(Paths.SHELL_COMMON_SCRIPTS_DIR / 'tari.sh')
    aliases["tarx"] = "tar -zxvf"

    # --------------------------------------------------------
    # grep
    # --------------------------------------------------------
    aliases.update({
        "grep": ["grep", "--color=auto"],
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
    # Git Dotfiles bare repo
    # --------------------------------------------------------
    aliases["gitdots"] = (
        f"/usr/bin/git --git-dir={Paths.HOME}/.git-dotfiles/ "
        f"--work-tree={Paths.HOME}"
    )

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
    # also dstatus alias
    aliases["dstatus"] = "gitdots status"

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

    aliases["pushb"] = ["lua", str(Paths.SHELL_COMMON_SCRIPTS_DIR / 'pushb.lua')]

    # --------------------------------------------------------
    # Abbreviations — cp replacement
    # --------------------------------------------------------
    abbrevs.update({
        "cpup": "rsync --progress -auv",
        "cp": "rsync --progress -av",
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
        "df": "df -h",
        "free": "free -m",
    })
 
    # --------------------------------------------------------
    # dmenu, rofi, wofi.
    # --------------------------------------------------------
    if not commandExists("dmenu"):
        if commandExists("rofi"):
            aliases["dmenu"] = ["rofi", "-dmenu"]
            aliases["dmenu_run"] = ["rofi", "-show","drun","-theme",str(Paths.HOME / '.config/rofi/themes/luci4-dmenu.rasi')] 
            abbrevs["fb"] = "rofi -show filebrowser"
        elif commandExists("wofi"):
            aliases["dmenu"] = ["wofi", "--dmenu"] 
     
    # --------------------------------------------------------
    # ls / tree (eza / exa)
    # --------------------------------------------------------
    if commandExists("eza"):
        aliases.update({
            "ls": "eza -a --color=always --group-directories-first --icons=always --mounts --git --git-repos",
            "tree": "eza -alh@ --color=always --group-directories-first --tree --level",
        })
        abbrevs["l"] = "eza -al --color=always --group-directories-first --icons=always --mounts --git --git-repos"

    elif commandExists("exa"):
        aliases.update({
            "ls": "exa -a --color=always --group-directories-first --icons",
            "tree": "exa -alh@ --color=always --group-directories-first --tree --level",
        })
        abbrevs["l"] = "exa -al --color=always --group-directories-first --icons"


