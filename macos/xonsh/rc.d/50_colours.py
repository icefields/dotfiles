import random
from enum import Enum
from enum import IntEnum

from xonsh.built_ins import XSH


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


def ansiColour(colour: ColourInt) -> str:
    return f"\033[{colour.value}m"


ColourAnsi = Enum("ColourAnsi", {c.name: ansiColour(c) for c in ColourInt})


def printColourInt(colour: ColourInt, text: str, end="\n"):
    print(f"\033[{colour}m{text}\033[0m", end=end)


def printColour(colour, text: str, end="\n"):
    if isinstance(colour, ColourInt):
        print(f"\033[{colour.value}m{text}\033[0m", end=end)
    elif isinstance(colour, ColourAnsi):
        print(f"{colour.value}{text}{ColourAnsi.RESET.value}", end=end)


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

__xonsh__.env["XONSH_COLOR_STYLE"] = random.choice(styles)

schemes = [
    "one-dark",
    "dracula",
    "nord",
    "gruvbox-dark",
    "alabaster_dark",
]
lsColour = random.choice(schemes)
chosenFile = Paths.COLOUR_SCHEMES_DIR / lsColour
try:
    XSH.env["LS_COLORS"] = chosenFile.read_text().strip()
except OSError:
    XSH.env["LS_COLORS"] = ""
