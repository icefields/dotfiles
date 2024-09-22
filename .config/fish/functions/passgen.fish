function passgen
    set password ($HOME/scripts/passgen.sh $argv[1])
    echo $password | xclip -selection clipboard
    echo $password
end
