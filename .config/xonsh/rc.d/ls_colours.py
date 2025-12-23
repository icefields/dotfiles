import random
import subprocess
from xonsh.built_ins import XSH
from pathlib import Path

ls_color_files = [
    Path.home() / "scripts/shell_common/colour_schemes/one-dark",
    Path.home() / "scripts/shell_common/colour_schemes/dracula",
    Path.home() / "scripts/shell_common/colour_schemes/nord",
    Path.home() / "scripts/shell_common/colour_schemes/gruvbox-dark",
    Path.home() / "scripts/shell_common/colour_schemes/alabaster_dark",
]

chosen_file = random.choice(ls_color_files)
XSH.env["LS_COLORS"] = chosen_file.read_text().strip()


# requires vivid installed

#schemes = [
#    "alabaster_dark", 
#    "gruvbox-dark", 
#    "nord", 
#    "one-dark"
#]

#lsColor = random.choice(schemes)

#XSH.env["LS_COLORS"] = __xonsh__.subproc_captured_stdout(
#    ["vivid", "generate", lsColor]
#).strip()

