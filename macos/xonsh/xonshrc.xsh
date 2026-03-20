# macOS xonsh entrypoint — link or include from ~/.xonshrc, e.g.:
#   ln -sf ~/path/to/my-dot-files/macos/xonsh/xonshrc.xsh ~/.xonshrc
#
# Optional: export DOTFILES="$HOME/path/to/my-dot-files" before launching xonsh.

import pathlib
import os

_dotfiles = pathlib.Path(os.environ.get("DOTFILES", pathlib.Path.home() / "my-dot-files")).resolve()
_rcdir = _dotfiles / "macos" / "xonsh" / "rc.d"
if not _rcdir.is_dir():
    print(f"[macos xonsh] rc.d not found: {_rcdir}")
else:
    for _f in sorted(_rcdir.glob("*.py")):
        source @(_f)
