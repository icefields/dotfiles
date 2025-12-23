function fish_greeting
	luci_greeting

	# Greeting messages
	set powered_msgs \
		"candy!" \
		"rubber bands" \
		"a black hole" \
		"logic" \
		"electromagnetic cheese" \
		"cats" \
		"kitties" \
		"Tessy!"

    set satanic_rules \
        "Do not give opinions or advice unless you are asked." \
        "Do not tell your troubles to others unless you are sure they want to hear them." \
        "When in another’s lair, show him respect or else do not go there." \
        "If a guest in your lair annoys you, treat him cruelly and without mercy." \
        "Do not make sexual advances unless you are given the mating signal." \
        "Do not take that which does not belong to you unless it is a burden to the other person and he cries out to be relieved." \
        "Acknowledge the power of magic if you have employed it successfully to obtain your desires." \
        "Do not complain about anything to which you need not subject yourself." \
        "Do not harm little children." \
        "Do not kill non-human animals unless you are attacked or for your food." \
        "When walking in open territory, bother no one. If someone bothers you, ask him to stop. If he does not stop, destroy him."

	set ascii_intros \
		"DarkOs" \
		"Anarchy" \
		"Anarchy" \
		"DragonFly" \
		"GNOME" \
		"GNU" \
		"Anarchy" \
		"Kali" \
		"DarkOs" \
	
	if test $OS_NAME = "Ubuntu"
	    set ubuntu_intros \
                "Ubuntu-Studio" \
                "Ubuntu-Studio" \  

        	set -a ascii_intros ubuntu_intros
        end

    # Randomly pick a satanic rule for this session
    set chosen_rule (random)"%"(count $satanic_rules)
    set chosen_rule $satanic_rules[(math $chosen_rule"+1")]
	
    # Randomly pick a intro graphic
	set chosen_ascii (random)"%"(count $ascii_intros)
	set chosen_ascii $ascii_intros[(math $chosen_ascii"+1")]
	fastfetch --disable-linewrap --logo $chosen_ascii
	
	echo " "
	
	# Randomly pick a message
	set chosen_msg (random)"%"(count $powered_msgs)
	set chosen_msg $powered_msgs[(math $chosen_msg"+1")]

	# Output it to the console
    printf (set_color F90)"Welcome! This terminal session is powered by %s\n" $chosen_msg
    set_color $fish_color_autosuggestion 
    echo "Satanic rule of the session: " (set_color blue; echo $chosen_rule;)
    set_color normal
    echo The time is (set_color yellow; date +%T; set_color normal). The OS is $OS_NAME on $hostname
end
