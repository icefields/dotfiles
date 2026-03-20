import os
import socket

def git_branch():
    """Return current git branch, or empty string if not in git repo"""
    try:
        import subprocess
        branch = subprocess.check_output(
            ["git", "branch", "--show-current"],
            stderr=subprocess.DEVNULL,
            text=True
        ).strip()
        return f" ({branch})" if branch else ""
    except Exception:
        return ""

def my_prompt():
    RESET = ColourAnsi.RESET.value
    userCol = ColourAnsi.YELLOW.value
    hostCol = ColourAnsi.BRIGHT_WHITE.value
    cwdCol = ColourAnsi.CYAN.value
    branchCol = ColourAnsi.MAGENTA.value
    promptCol = ColourAnsi.DARK_GREEN.value

    user = os.environ.get("USER", "user")
    host = socket.gethostname().split(".")[0]
    cwd = os.getcwd()
    branch = git_branch()
    
    spacing = "\n"
    if len(cwd) < 22:
        spacing = ""

    return (
        f"{userCol}{user}{RESET}@{hostCol}{host}{RESET}:"
        f"{cwdCol}{cwd}{RESET}"
        f"{branchCol}{branch}{RESET}{spacing}"
        f"{promptCol}  {RESET}"
    )

__xonsh__.env['PROMPT'] = my_prompt

# __xonsh__.env['PROMPT'] = '{user}@{hostname}:{cwd}    '
