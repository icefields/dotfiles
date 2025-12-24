import random
import subprocess
from xonsh.built_ins import XSH
from pathlib import Path

# theme
styles = [
    "rrt",
    "monokai",
    "github-dark",
    "material",
    "nord",
    "one-dark",
    "nord-darker",
    "paraiso-dark",
    "native",
    "fruity",
    "vim",
]

__xonsh__.env['XONSH_COLOR_STYLE'] = random.choice(styles)

## ls colours
basePath = Path.home() / "scripts/shell_common/colour_schemes"
schemes = [
    "one-dark",
    "dracula",
    "nord",
    "gruvbox-dark",
    "alabaster_dark",
]
lsColour = random.choice(schemes)
chosenFile = basePath / lsColour
XSH.env["LS_COLORS"] = chosenFile.read_text().strip()

# Alternate solution, requires vivid installed
#XSH.env["LS_COLORS"] = __xonsh__.subproc_captured_stdout(
#    ["vivid", "generate", lsColor]
#).strip()

