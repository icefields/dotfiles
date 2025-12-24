# ~/.config/xonsh/rc.py
import os
import socket

# ANSI colors
RESET = "\033[0m"
DARK_GREEN = "\033[32m"
BLUE = "\033[34m"
CYAN = "\033[36m"
MAGENTA = "\033[35m"
YELLOW = "\033[33m"

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
    user = os.environ.get("USER", "user")
    host = socket.gethostname().split(".")[0]
    cwd = os.getcwd()
    branch = git_branch()
    return (
        f"{YELLOW}{user}{RESET}@{BLUE}{host}{RESET}:"
        f"{CYAN}{cwd}{RESET}"
        f"{MAGENTA}{branch}{RESET}\n "
        f"{DARK_GREEN}  {RESET} "
    )

__xonsh__.env['PROMPT'] = my_prompt

# __xonsh__.env['PROMPT'] = '{user}@{hostname}:{cwd}    '
