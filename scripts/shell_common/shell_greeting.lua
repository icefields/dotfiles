local scriptPath = debug.getinfo(1, "S").source:match("^@(.+)/")
if scriptPath then
    package.path = package.path .. ";" .. scriptPath .. "/midori-fetch/midorifetch_lib.lua"
end

local midoriFetch = require("midorifetch_lib")

local function colorText(color, text)
    return "\27[" .. color .. "m" .. text .. "\27[0m"
end

-- Function to check if a command exists
local function commandExists(cmd)
    local result = os.execute("which " .. cmd .. " >/dev/null 2>&1")
    return result == 0 or result == true
end

math.randomseed(os.time())

local satanic_rules = {
    "Do not give opinions or advice unless you are asked.",
    "Do not tell your troubles to others unless you are sure they want to hear them.",
    "When in another’s lair, show him respect or else do not go there.",
    "If a guest in your lair annoys you, treat him cruelly and without mercy.",
    "Do not make sexual advances unless you are given the mating signal.",
    "Do not take that which does not belong to you unless it is a burden to the other person and he cries out to be relieved.",
    "Acknowledge the power of magic if you have employed it successfully to obtain your desires.",
    "Do not complain about anything to which you need not subject yourself.",
    "Do not harm little children.",
    "Do not kill non-human animals unless you are attacked or for your food.",
    "When walking in open territory, bother no one. If someone bothers you, ask him to stop. If he does not stop, destroy him."
}

-- local chosen_msg = powered_msgs[math.random(#powered_msgs)]
local chosen_rule = satanic_rules[math.random(#satanic_rules)]

-- Print the greeting
if commandExists("fastfetch") then
    local ascii_intros = {
        "DarkOs", "Anarchy", "DragonFly", "GNOME", "GNU", "Kali"
    }
    local chosen_ascii = ascii_intros[math.random(#ascii_intros)]
    os.execute("fastfetch --disable-linewrap --logo " .. chosen_ascii)
else
    midoriFetch.display(scriptPath .. "/midori-fetch/hypno.txt")
end

print(colorText(35,"Satanic rule of the session: ") .. colorText(32, chosen_rule))

