import os
import shutil
import subprocess

from xonsh.built_ins import XSH

if not XSH.env.get("XONSH_INTERACTIVE", False):
    pass
else:
    keyCol = ColourAnsi.BRIGHT_BLACK
    valCol = ColourAnsi.BRIGHT_GREEN

    scriptsDir = str(Paths.SHELL_COMMON_SCRIPTS_DIR)
    luci_sh = os.path.join(scriptsDir, "luci_greeting.sh")
    luci_lua = os.path.join(scriptsDir, "shell_greeting.lua")

    if os.path.isfile(luci_sh):
        subprocess.run([luci_sh], check=False)
    lua = shutil.which("lua")
    if lua and os.path.isfile(luci_lua):
        subprocess.run([lua, luci_lua], check=False)

    if isDistrobox():
        printColour(keyCol, "CONTAINER_ID", end="")
        printColour(valCol, XSH.env["CONTAINER_ID"], end="")
        print(" ", end="")

    printColour(keyCol, "OS_NAME", end="")
    printColour(valCol, XSH.env["OS_NAME"], end="")
    print(" ", end="")
    printColour(keyCol, "LS_COLORS", end="")
    printColour(valCol, lsColour, end="")
    print(" ", end="")
    printColour(keyCol, "XONSH_COLOR_STYLE", end="")
    printColour(valCol, XSH.env["XONSH_COLOR_STYLE"], end="")
    print(" ", end="")
    printColour(keyCol, "EDITOR", end="")
    printColour(valCol, XSH.env["EDITOR"])
