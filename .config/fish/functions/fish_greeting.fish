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

	# Randomly pick a intro graphic
	set chosen_ascii (random)"%"(count $ascii_intros)
	set chosen_ascii $ascii_intros[(math $chosen_ascii"+1")]
	neofetch --ascii_distro $chosen_ascii
	
	echo " "
	
	# Randomly pick a message
	set chosen_msg (random)"%"(count $powered_msgs)
	set chosen_msg $powered_msgs[(math $chosen_msg"+1")]

	# Output it to the console
	printf (set_color F90)"Welcome! This terminal session is powered by %s\n" $chosen_msg
	set_color $fish_color_autosuggestion
  	echo "I'm completely operational, all my circuits are functioning perfectly."
  	set_color normal
	echo The time is (set_color yellow; date +%T; set_color normal). The OS is $OS_NAME on $hostname
	#echo " " 
end
