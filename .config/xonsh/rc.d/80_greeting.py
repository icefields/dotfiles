# --------------------------------------------------------
# Greeting
# --------------------------------------------------------
# Call this after all the env vars are set
# --------------------------------------------------------

scriptsDir = os.path.expanduser("~/scripts/shell_common")

#subprocess.run(["lua", os.path.join(scriptsDir, "luci_greeting.lua")])
subprocess.run([os.path.join(scriptsDir, "luci_greeting.sh")])
subprocess.run(["lua", os.path.join(scriptsDir, "shell_greeting.lua")])

def printColour(colour, text, end="\n"):
    print(f"\033[{colour}m{text}\033[0m", end = end)

keyCol = 90
valCol = 92

if os.environ.get("CONTAINER_ID"):
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

#BLUE="\e[34m"
#MAGENTA="\e[35m"
#CYAN="\e[36m"
#RED="\e[31m"
#GREEN="\e[32m"
#YELLOW="\e[33m"
#BRIGHT_BLACK="\e[90m"
#BRIGHT_RED="\e[91m"
#BRIGHT_GREEN="\e[92m"
#RESET="\e[0m"

