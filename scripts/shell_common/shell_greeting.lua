-- xonsh_greeting.lua

math.randomseed(os.time())

local powered_msgs = {
    "candy!", "rubber bands", "a black hole", "logic",
    "electromagnetic cheese", "cats", "kitties", "Tessy!"
}

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

local ascii_intros = {
    "DarkOs", "Anarchy", "DragonFly", "GNOME", "GNU", "Kali"
}

local chosen_msg = powered_msgs[math.random(#powered_msgs)]
local chosen_rule = satanic_rules[math.random(#satanic_rules)]
local chosen_ascii = ascii_intros[math.random(#ascii_intros)]

-- Print the greeting
os.execute("fastfetch --disable-linewrap --logo " .. chosen_ascii)

print("Welcome! This terminal session is powered by " .. chosen_msg)
print("Satanic rule of the session: " .. chosen_rule)

