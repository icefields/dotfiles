import subprocess
import os
# --------------------------------------------------------
# Greeting
# --------------------------------------------------------
# Call this after all the env vars are set
# --------------------------------------------------------

scriptsDir = str(Paths.SHELL_COMMON_SCRIPTS_DIR) 
# os.path.expanduser("~/scripts/shell_common")

#subprocess.run(["lua", os.path.join(scriptsDir, "luci_greeting.lua")])
subprocess.run([os.path.join(scriptsDir, "luci_greeting.sh")])
subprocess.run(["lua", os.path.join(scriptsDir, "shell_greeting.lua")])


keyCol = ColourAnsi.BRIGHT_BLACK
valCol = ColourAnsi.BRIGHT_GREEN

if isDistrobox():
    printColour(keyCol, "CONTAINER_ID", end = "")
    printColour(valCol, XSH.env["CONTAINER_ID"], end = "")
    print(" ", end = "")

printColour(keyCol, "OS_NAME", end = "")
printColour(valCol, XSH.env["OS_NAME"], end = "")
print(" ", end = "")
printColour(keyCol, "LS_COLORS", end = "")
printColour(valCol, lsColour, end = "")
print(" ", end = "")
printColour(keyCol, "XONSH_COLOR_STYLE", end = "")
printColour(valCol, XSH.env["XONSH_COLOR_STYLE"], end = "")
print(" ", end = "")
printColour(keyCol, "EDITOR", end = "")
printColour(valCol, XSH.env["EDITOR"])

