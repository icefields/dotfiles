import random
import subprocess
from xonsh.built_ins import XSH
from pathlib import Path

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


def printColour(colour, text, end="\n"):
    print(f"\033[{colour}m{text}\033[0m", end = end)

printColour("32", "LS_COLORS", end = "")
printColour("35", lsColour, end = "")
print(",", end = "")
printColour("32", "OS_NAME", end = "")
printColour("35", XSH.env["OS_NAME"])

# Alternate solution, requires vivid installed
#XSH.env["LS_COLORS"] = __xonsh__.subproc_captured_stdout(
#    ["vivid", "generate", lsColor]
#).strip()

