import random
import subprocess
from xonsh.built_ins import XSH
from pathlib import Path
from enum import IntEnum
from enum import Enum

class ColourInt(IntEnum):
    BLUE = 34
    MAGENTA = 35
    CYAN = 36
    RED = 31
    YELLOW = 33
    BRIGHT_BLACK = 90
    BRIGHT_RED = 91
    DARK_GREEN = 32
    BRIGHT_GREEN = 92
    BRIGHT_YELLOW = 93
    BRIGHT_BLUE = 94
    BRIGHT_MAGENTA = 95
    BRIGHT_CYAN = 96
    BRIGHT_WHITE = 97
    RESET = 0

# This function converts an integer code into an ANSI escape sequence string
def ansiColour(colour: ColourInt) -> str:
    return f"\033[{colour.value}m"

# Step 3: Dynamically create the ColourAnsi enum using the values from ColourInt.
ColourAnsi = Enum('ColourAnsi', {colour.name: ansiColour(colour) for colour in ColourInt})

def printColourInt(colour: ColourInt, text: str, end="\n"):
    print(f"\033[{colour}m{text}\033[0m", end = end)

# Step 4: Function to print text with the desired color
def printColour(colour, text: str, end="\n"):
    if isinstance(colour, ColourInt):
        print(f"\033[{colour.value}m{text}\033[0m", end = end)
    elif isinstance(colour, ColourAnsi):
        print(f"{colour.value}{text}{ColourAnsi.RESET.value}", end=end)

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

