# macOS xonsh rc — based on linux/.config/xonsh/rc.d/00_rc.py (Linux tree unchanged).
# Strict XDG defaults, Bun/Cursor/LM Studio layout, and macOS-only interactive config.

import os
import platform
import shutil
import subprocess
import warnings
from pathlib import Path

from xonsh.built_ins import XSH
from xonsh.xontribs import xontribs_load

# ---------------------------------------------------------------------------
# Strict XDG base dirs (set early for all xonsh invocations)
# ---------------------------------------------------------------------------

_HOME = Path.home()


def _xdg_path(env_key: str, default: Path) -> Path:
    raw = os.environ.get(env_key)
    p = Path(raw).expanduser() if raw else default
    return p.resolve()


def _apply_xdg_bootstrap() -> None:
    cfg = _xdg_path("XDG_CONFIG_HOME", _HOME / ".config")
    data = _xdg_path("XDG_DATA_HOME", _HOME / ".local" / "share")
    cache = _xdg_path("XDG_CACHE_HOME", _HOME / ".cache")
    state = _xdg_path("XDG_STATE_HOME", _HOME / ".local" / "state")

    for key, path in (
        ("XDG_CONFIG_HOME", cfg),
        ("XDG_DATA_HOME", data),
        ("XDG_CACHE_HOME", cache),
        ("XDG_STATE_HOME", state),
    ):
        s = str(path)
        os.environ[key] = s
        XSH.env[key] = s

    # Bun — install + cache under XDG_CONFIG_HOME (matches macos/scripts/xdg.swift)
    bun_root = cfg / "bun"
    bun_cache = bun_root / "install" / "cache"
    os.environ["BUN_INSTALL"] = str(bun_root)
    XSH.env["BUN_INSTALL"] = str(bun_root)
    os.environ["BUN_INSTALL_CACHE_DIR"] = str(bun_cache)
    XSH.env["BUN_INSTALL_CACHE_DIR"] = str(bun_cache)

    # LM Studio — under XDG_CONFIG_HOME (see README; large models should use LM_STUDIO_MODELS_DIR)
    lm_home = cfg / "lm-studio"
    os.environ["LM_STUDIO_HOME"] = str(lm_home)
    XSH.env["LM_STUDIO_HOME"] = str(lm_home)
    models_dir = _HOME / "Desktop" / "LMStudio-Models"
    os.environ["LM_STUDIO_MODELS_DIR"] = str(models_dir)
    XSH.env["LM_STUDIO_MODELS_DIR"] = str(models_dir)

    # Cursor — prefer documented config dir (macOS may still touch ~/.cursor for some assets)
    cursor_cfg = cfg / "cursor"
    cursor_cfg.mkdir(parents=True, exist_ok=True)
    s = str(cursor_cfg)
    os.environ["CURSOR_CONFIG_DIR"] = s
    XSH.env["CURSOR_CONFIG_DIR"] = s

    # Optional: Docker CLI config location
    docker_cfg = cfg / "docker"
    docker_cfg.mkdir(parents=True, exist_ok=True)
    os.environ["DOCKER_CONFIG"] = str(docker_cfg)
    XSH.env["DOCKER_CONFIG"] = str(docker_cfg)

    # PATH: Bun + LM Studio CLI (dedupe)
    path = os.environ.get("PATH", "")
    parts = path.split(":") if path else []

    def _prepend(p: str) -> None:
        if p and Path(p).is_dir() and p not in parts:
            parts.insert(0, p)

    _prepend(str(bun_root / "bin"))
    _prepend(str(lm_home / "bin"))

    new_path = ":".join(parts)
    os.environ["PATH"] = new_path
    XSH.env["PATH"] = new_path


_apply_xdg_bootstrap()

if platform.system() == "Darwin":
    _os_name = subprocess.check_output(
        ["sw_vers", "-productName"], text=True
    ).strip()
    os.environ["OS_NAME"] = _os_name
    XSH.env["OS_NAME"] = _os_name


class Paths:
    HOME = _HOME
    XDG_CONFIG = Path(XSH.env["XDG_CONFIG_HOME"])
    XDG_DATA = Path(XSH.env["XDG_DATA_HOME"])
    XDG_CACHE = Path(XSH.env["XDG_CACHE_HOME"])
    XDG_STATE = Path(XSH.env["XDG_STATE_HOME"])
    LOG_DIR = XDG_STATE / "xonsh"
    SCRIPTS_DIR = HOME / "scripts"
    SHELL_COMMON_SCRIPTS_DIR = HOME / "scripts" / "shell_common"
    COLOUR_SCHEMES_DIR = SHELL_COMMON_SCRIPTS_DIR / "colour_schemes"
    LOG_FILE = LOG_DIR / "xonsh_traceback.log"
    ENV_VARS = XDG_CONFIG / "xonsh" / "shell_env"
    HISTORY_FILE = XDG_DATA / "xonsh" / "xonsh_history"
    HISTORY_DB = XDG_DATA / "xonsh" / "xonsh_history.db"


Paths.LOG_DIR.mkdir(parents=True, exist_ok=True)
Paths.ENV_VARS.parent.mkdir(parents=True, exist_ok=True)
(Paths.HOME / "Desktop" / "LMStudio-Models").mkdir(parents=True, exist_ok=True)

# xontrib-kitty has some deprecations in the code
warnings.filterwarnings(
    "ignore",
    category=DeprecationWarning,
    module=r"xontrib_kitty.*",
)

__xonsh__.env["XONSH_SHOW_TRACEBACK"] = True
__xonsh__.env["XONSH_TRACEBACK_LOGFILE"] = str(Paths.LOG_FILE)


def _command_exists(cmd: str) -> bool:
    return shutil.which(cmd) is not None


def _is_distrobox() -> bool:
    return "CONTAINER_ID" in os.environ


def isDistrobox():
    """Linux rc files (e.g. 80_greeting.py) expect this name in the shared namespace."""
    return _is_distrobox()


# ------------------------------------------------------------
# Interactive guard (macOS profile)
# ------------------------------------------------------------
if not XSH.env.get("XONSH_INTERACTIVE", False):
    pass
else:
    xontribs_load(["abbrevs"])
    abbrevs = XSH.ctx["abbrevs"]
    aliases = XSH.aliases
    try:
        xontribs_load(["fish_completer"])
    except Exception as e:
        print(f"[macos xonsh] fish_completer skipped: {e}")
    try:
        xontribs_load(["kitty"])
    except Exception as e:
        print(f"[macos xonsh] kitty xontrib skipped: {e}")

    __xonsh__.env["PROMPT_TOOLKIT_COLOR_DEPTH"] = "DEPTH_24_BIT"
    __xonsh__.env["XONSH_AUTOSUGGESTION"] = "prompt_toolkit"
    __xonsh__.env["XONSH_COMPLETIONS_DISPLAY"] = "multi"
    __xonsh__.env["COMPLETIONS_DISPLAY"] = "multi"
    __xonsh__.env["XONSH_COMPLETIONS_IGNORE_CASE"] = True
    __xonsh__.env["CASE_SENSITIVE_COMPLETIONS"] = False
    __xonsh__.env["XONSH_COMPLETIONS_MENU_COMPLETION"] = True
    __xonsh__.env["COMPLETION_MODE"] = "menu-complete"
    __xonsh__.env["UPDATE_COMPLETIONS_ON_KEYPRESS"] = False
    __xonsh__.env["FUZZY_PATH_COMPLETION"] = True
    __xonsh__.env["SUBSEQUENCE_PATH_COMPLETION"] = True
    __xonsh__.env["COMPLETIONS_MENU_ROWS"] = 6
    __xonsh__.env["COMPLETIONS_CONFIRM"] = False
    __xonsh__.env["XONSH_HISTORY_MATCH_ANYWHERE"] = True
    __xonsh__.env["UPDATE_PROMPT_ON_KEYPRESS"] = True
    __xonsh__.env["XONSH_AUTOPAIR"] = True
    __xonsh__.env["COMPLETION_IN_THREAD"] = True

    XSH.env["CARAPACE_BRIDGES"] = "zsh,fish,bash"
    XSH.env["COMPLETIONS_CONFIRM"] = True
    try:
        exec(__xonsh__.subproc_captured_stdout(["carapace", "_carapace", "xonsh"]))
    except Exception as e:
        print(f"[macos xonsh] carapace init skipped: {e}")

    if _is_distrobox():
        __xonsh__.env["XONSH_HISTORY_FILE"] = str(Paths.HISTORY_FILE)
        __xonsh__.env["XONSH_HISTORY_SIZE"] = 10000
        __xonsh__.env["HISTCONTROL"] = "ignoredups"
    else:
        Paths.HISTORY_FILE.parent.mkdir(parents=True, exist_ok=True)
        __xonsh__.env["XONSH_HISTORY_FILE"] = str(Paths.HISTORY_DB)
        __xonsh__.env["XONSH_HISTORY_BACKEND"] = "sqlite"
        __xonsh__.env["XONSH_HISTORY_SIZE"] = 100000
        __xonsh__.env["HISTCONTROL"] = "erasedups"

    XSH.env["EDITOR"] = "nvim"
    XSH.env["MANPAGER"] = "nvim +Man!"

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

    abbrevs.update({
        "dad": "gitdots add",
        "dstatus": "gitdots status",
        "ddiff": "gitdots diff",
        "dcom": "gitdots commit -m ",
        "dpus": "gitdots push -u origin main",
    })

    abbrevs.update({
        "cpup": "rsync --progress -auv",
        "cp": "rsync --progress -av",
    })

    aliases.update({
        "grep": "grep --color=auto",
        "egrep": "egrep --color=auto",
        "fgrep": "fgrep --color=auto",
    })

    aliases[".."] = "cd .."
    aliases["..."] = "cd ../.."
    aliases["...."] = "cd ../../.."
    aliases["home"] = "cd ~"
    aliases["desk"] = "cd ~/Desktop"
    aliases["docs"] = "cd ~/Documents"
    aliases["downloads"] = "cd ~/Downloads"

    _gpg = shutil.which("gpg2") or shutil.which("gpg")
    if _gpg:
        aliases.update(
            {
                "gpg-check": f"{_gpg} --keyserver-options auto-key-retrieve --verify",
                "gpg-retrieve": f"{_gpg} --keyserver-options auto-key-retrieve --receive-keys",
            }
        )

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

    # zsh-style git shorts (names do not overlap existing xonsh git aliases above)
    aliases.update({
        "gs": "git status",
        "ga": "git add",
        "gc": "git commit -m",
        "gp": "git push",
        "gl": "git log --oneline",
        "gco": "git checkout",
        "gcb": "git checkout -b",
        "gb": "git branch",
        "gd": "git diff",
        "grh": "git reset --hard HEAD",
    })

    aliases.update({
        "psa": "ps auxf",
        "psgrep": "ps aux | grep -v grep | grep -i -e VSZ -e",
        "psmem": "ps auxf | sort -nr -k 4",
        "pscpu": "ps auxf | sort -nr -k 3",
    })

    aliases.update({
        ":q": "exit",
        "df": "df -h",
        "free": "vm_stat",
        "ports": "lsof -i -P -n | grep LISTEN",
        "myip": "curl -s https://ipinfo.io/ip",
        "weather": "curl -s wttr.in",
        "showfiles": "defaults write com.apple.finder AppleShowAllFiles YES; killall Finder",
        "hidefiles": "defaults write com.apple.finder AppleShowAllFiles NO; killall Finder",
        "flushdns": "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder",
        "venv": "python3 -m venv venv",
        "npmg": "npm list -g --depth=0",
        "npml": "npm list --depth=0",
        "tk": "tmux kill-server",
        "reloadtmux": 'tmux source-file ~/.tmux.conf 2>/dev/null || echo "tmux config not found"',
        "c": "clear",
    })

    _agent = shutil.which("agent")
    if _agent:
        aliases["agent"] = _agent

    if _command_exists("gdb"):
        aliases.update(
            {
                "gdb-python": 'gdb -ex "set python print-stack none"',
                "gdb-tui": "gdb -tui",
                "gdb-batch": 'gdb -batch -ex "run" -ex "bt" -ex "quit"',
            }
        )

    _git_bin = shutil.which("git") or "/usr/bin/git"
    aliases["gitdots"] = (
        f"{_git_bin} --git-dir={Paths.HOME}/.git-dotfiles/ "
        f"--work-tree={Paths.HOME}"
    )

    if _command_exists("nvim"):
        aliases["vim"] = "nvim"

    if _command_exists("eza"):
        aliases.update({
            "ls": "eza -a --color=always --group-directories-first --icons=always --mounts --git --git-repos",
            "tree": "eza -alh@ --color=always --group-directories-first --tree --level",
            "ll": "eza -la --color=always --group-directories-first --icons=always --mounts --git --git-repos",
            "la": "eza -a --color=always --group-directories-first --icons=always --mounts --git --git-repos",
        })
        abbrevs["l"] = "eza -al --color=always --group-directories-first --icons=always --mounts --git --git-repos"
    elif _command_exists("exa"):
        aliases.update({
            "ls": "exa -a --color=always --group-directories-first --icons",
            "tree": "exa -alh@ --color=always --group-directories-first --tree --level",
            "ll": "exa -la --color=always --group-directories-first --icons",
            "la": "exa -a --color=always --group-directories-first --icons",
        })
        abbrevs["l"] = "exa -al --color=always --group-directories-first --icons"
    else:
        aliases.update({
            "ll": "ls -la",
            "la": "ls -A",
            "l": "ls -CF",
            "ls": "ls -G",
        })

    if _is_distrobox():
        XSH.env.pop("SESSION_MANAGER", None)
        if Path.cwd() != Paths.HOME:
            os.chdir(Paths.HOME)

    if _command_exists("bat"):
        abbrevs["ca"] = "bat --color=always"
        aliases["cat"] = "bat -p --color=always"

    if _command_exists("brew"):
        abbrevs["brewup"] = "brew update && brew upgrade && brew cleanup"

    aliases["333"] = "source ~/.xonshrc"
    aliases["reload"] = "source ~/.xonshrc"
