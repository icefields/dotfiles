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
from enum import Enum
import shutil

class Paths:
    HOME = Path.home()
    LOG_DIR = HOME / '.pyvenvs/xonsh-env'
    SCRIPTS_DIR = HOME / 'scripts'
    SHELL_COMMON_SCRIPTS_DIR = HOME / 'scripts/shell_common'
    WM_COMMON_SCRIPTS_DIR = HOME / 'scripts/wm_common'
    COLOUR_SCHEMES_DIR = SHELL_COMMON_SCRIPTS_DIR / 'colour_schemes'
    LOG_FILE = LOG_DIR / 'xonsh_traceback.log'
    ENV_VARS = HOME / '.shell_env'
    HISTORY_FILE = HOME / '.xonsh_history'
    HISTORY_DB = HOME / '.xonsh_history.db'

# xontrib-kitty has some deprecations in the code
warnings.filterwarnings(
    "ignore",
    category=DeprecationWarning,
    module=r"xontrib_kitty.*",
)

# Enable full traceback of errors
# create log dir if not exists, comment out to just generate an error at startup.
# Paths.LOG_DIR.mkdir(parents=True, exist_ok=True)
__xonsh__.env['XONSH_SHOW_TRACEBACK'] = True
__xonsh__.env['XONSH_TRACEBACK_LOGFILE'] = str(Paths.LOG_FILE)

# --------------------------------------------------------
# Helpers
# --------------------------------------------------------
def commandExists(cmd):
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

# Interactive guard
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
    # ----------------------------------------------------------------
    __xonsh__.env['PROMPT_TOOLKIT_COLOR_DEPTH'] = 'DEPTH_24_BIT'
    __xonsh__.env['XONSH_AUTOSUGGESTION'] = 'prompt_toolkit' #'readline'
    __xonsh__.env['XONSH_COMPLETIONS_DISPLAY'] = 'multi'
    __xonsh__.env['COMPLETIONS_DISPLAY'] = 'multi'
    __xonsh__.env['XONSH_COMPLETIONS_IGNORE_CASE'] = True
    __xonsh__.env['CASE_SENSITIVE_COMPLETIONS'] = False
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
    __xonsh__.env['COMPLETION_IN_THREAD'] = True

    # Carapace auto-complete suggestions
    XSH.env["CARAPACE_BRIDGES"] = "zsh,fish,bash"  # inshellisense
    XSH.env["COMPLETIONS_CONFIRM"] = True
    # Execute carapace initialization
    exec(__xonsh__.subproc_captured_stdout(["carapace", "_carapace", "xonsh"]))

    # history settings
    # HISTCONTROL - ignoredups  will not save the command if it matches the previous command, erasedups  will remove all previous commands that matches and updates the frequency (only supported in sqlite)
    if isDistrobox():
        __xonsh__.env['XONSH_HISTORY_FILE'] = str(Paths.HISTORY_FILE)
        __xonsh__.env['XONSH_HISTORY_SIZE'] = 10000
        __xonsh__.env['HISTCONTROL'] = 'ignoredups'
    else:
        __xonsh__.env['XONSH_HISTORY_FILE'] = str(Paths.HISTORY_DB)
        __xonsh__.env['XONSH_HISTORY_BACKEND'] = 'sqlite'
        __xonsh__.env['XONSH_HISTORY_SIZE'] = 100000
        __xonsh__.env['HISTCONTROL'] = 'erasedups'
 
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
        if Path.cwd() != Paths.HOME:
            os.chdir(Paths.HOME)

