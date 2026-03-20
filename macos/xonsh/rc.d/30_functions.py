# macOS — script aliases only when targets exist; no Linux-friend / Asahi / tor shortcuts.

import shutil
import subprocess
from pathlib import Path


def _bind_if_file(path: Path, alias_name: str, value) -> None:
    if path.is_file():
        aliases[alias_name] = value


_bind_if_file(Paths.SHELL_COMMON_SCRIPTS_DIR / "tari.sh", "tari", str(Paths.SHELL_COMMON_SCRIPTS_DIR / "tari.sh"))
aliases["tarx"] = "tar -zxvf"
lua = shutil.which("lua")
_pushb = Paths.SHELL_COMMON_SCRIPTS_DIR / "pushb.lua"
if lua and _pushb.is_file():
    aliases["pushb"] = [lua, str(_pushb)]

_bind_if_file(
    Paths.SHELL_COMMON_SCRIPTS_DIR / "backup.sh",
    "backup",
    str(Paths.SHELL_COMMON_SCRIPTS_DIR / "backup.sh"),
)
for name, extra in (
    ("share", "--ntfy -p"),
    ("sharesec", "--ntfy --secret -p"),
    ("sharemega", "-m --ntfy --secret -p"),
):
    sh = Paths.SCRIPTS_DIR / "share.sh"
    if sh.is_file():
        aliases[name] = str(sh) + " " + extra

_bind_if_file(
    Paths.SHELL_COMMON_SCRIPTS_DIR / "passgen_wrapper.sh",
    "passgen",
    str(Paths.SHELL_COMMON_SCRIPTS_DIR / "passgen_wrapper.sh"),
)

if shutil.which("fzf"):
    if shutil.which("pbcopy"):
        aliases["getpath"] = r"find . -type f | fzf | tr -d '\n' | pbcopy"
    elif shutil.which("xclip"):
        aliases["getpath"] = "find . -type f | fzf | sed 's/^..//' | tr -d '\\n' | xclip -selection c"


def currency_convert(multiplier=1, pair="USD/CAD"):
    api_url = __xonsh__.env.get("CURRENCY_API")
    if not api_url:
        raise RuntimeError("Set CURRENCY_API in shell_env (see shell_env.example).")
    cmd = f'curl -s {api_url} | jq -r \'.result["{pair}"]\''
    rate_str = subprocess.check_output(cmd, shell=True, text=True).strip()
    return float(rate_str) * multiplier
