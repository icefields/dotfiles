# # # # # # # # # # # # # # # # # # # # # # # # # # # #
#-- ----------------------------------------------- --#
#--   ▄        ▄     ▄  ▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄  ▄     ▄   --#
#--  ▐░▌      ▐░▌   ▐░▌▐░█▀▀▀▀▀  ▀▀█░█▀▀ ▐░▌   ▐░▌  --#
#--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░█   █░▌  --#
#--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌   ▐░░░░░░░▌  --#
#--  ▐░▌      ▐░▌   ▐░▌▐░▌         ▐░▌    ▀▀▀▀▀█░▌  --#
#--  ▐░█▄▄▄▄▄ ▐░█▄▄▄█░▌▐░█▄▄▄▄▄  ▄▄█░█▄▄       ▐░▌  --#
#--   ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀  ▀▀▀▀▀▀▀        ▀   --#
#-- ----------------------------------------------- --#
#-- -------- Luci4 config for Fish Shell  --------- --#
#-- -------- https://github.com/icefields --------- --#
#-----------------------------------------------------#
#                                                     #---------#
# Config files sourcing order in Fish Shell:                    #
#                                                               #
# 1. **`config.fish`**: This is the main configuration file.    #
#    It's sourced first. Located in `~/.config/fish/`.          #
#                                                               #
# 2. **`conf.d` directory**: Files in `~/.config/fish/conf.d/`  #
#    directory are sourced after `config.fish`.                 #
#    In lexicographical order (alphabetically).                 #
#                                                               #
# Files inside `conf.d` can be prefixed by a number to control  #
# their order of execution.                                     #
#                                                               #
# If there are any conflicting settings, the files in `conf.d/` #
# could override settings from `config.fish`.                   #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

if status is-interactive
    ### POWERLINE FONTS ###
    # this messes up bobthefish theme
    #set fish_function_path $fish_function_path "/usr/share/powerline/bindings/fish"
    #source /usr/share/powerline/bindings/fish/powerline-setup.fish
    #powerline-setup

    set -gx EDITOR nvim 

    ### SET MANPAGER
    ### Uncomment only one of these!
    ### "nvim" as manpager
    set -x MANPAGER "nvim +Man!"
    ### "less" as manpager
    # set -x MANPAGER "less"
    # export MANPAGER="/bin/sh -c \"col -b | vim --not-a-term -c 'set ft=man ts=8 nomod nolist noma' -\""

    ### ABBREVIATIONS ###
    # git
    abbr --add ad git add .
    abbr --add pus git push -u origin 
    abbr --add pum git push -u origin main 
    abbr --add pud git push -u origin dev 
    abbr --add com git commit -m \"
    abbr --add chb git checkout -b
    abbr --add che git checkout   
    abbr --add pul git pull
    
    # gitdots abbreviatons
    abbr --add dad gitdots add
    abbr --add dstatus gitdots status
    abbr --add ddiff gitdots diff
    abbr --add dcom gitdots commit -m \"
    abbr --add dpus gitdots push -u origin main 

    # cp replacement
    abbr --add cpup rsync --progress -auv # copy only if the destination is older
    abbr --add cp rsync --progress -av

    ### ALIASES ###
    # Colorize grep output (good for log files)
    alias grep='grep --color=auto'
    alias egrep='egrep --color=auto'
    alias fgrep='fgrep --color=auto'

    # navigation
    alias ..='cd ..'
    alias ...='cd ../..'
    alias .3='cd ../../..'
    alias .4='cd ../../../..'
    alias .5='cd ../../../../..'

    # get error messages from journalctl
    alias jctl="journalctl -p 3 -xb"

    # gpg encryption
    # verify signature for isos
    alias gpg-check="gpg2 --keyserver-options auto-key-retrieve --verify"
    # receive the key of a developer
    alias gpg-retrieve="gpg2 --keyserver-options auto-key-retrieve --receive-keys"

    # git
    alias addup='git add -u'
    alias addall='git add .'
    alias branch='git branch'
    alias checkout='git checkout'
    alias clone='git clone'
    alias commit='git commit -m'
    alias fetch='git fetch'
    alias pull='git pull'
    alias push='git push -u origin'
    alias tag='git tag'
    alias newtag='git tag -a'

    # ps
    alias psa="ps auxf"
    alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
    alias psmem='ps auxf | sort -nr -k 4'
    alias pscpu='ps auxf | sort -nr -k 3'

    # ALIASES (misc)
    alias getpath="find -type f | fzf | sed 's/^..//' | tr -d '\n' | xclip -selection c"
    alias tree="exa -alh@ --color=always --group-directories-first --tree --level"
    alias tarx="tar -zxvf" # de-archive a tar file. USE 'tari filename' to compress
    alias :q='exit'
    alias toreset="$HOME/scripts/tor_relay_reset.sh"
    alias toripify="torsocks wget -qO - https://api.ipify.org; echo" 

    # Reboot to macOS on dual-boot with Asahi Linux.
    alias rebootToMac="sudo sh -c 'echo 1 | asahi-bless; reboot'"
    
    # adding flags
    alias df='df -h'                          # human-readable sizes
    alias free='free -m'                      # show sizes in MB

    ### DOT FILES BACKUP, BARE REPO
    alias gitdots='/usr/bin/git --git-dir=$HOME/.git-dotfiles/ --work-tree=$HOME'

    # VIM - NVIM
    # if vim doesn't exist but nvim does exist, alias vim -> nvim
    # if not command -v vim > /dev/null
        if command -v nvim > /dev/null
            alias vim='nvim'
        end
    # end

    # LS
    if command -v eza > /dev/null
        alias ls='eza -a --color=always --group-directories-first --icons=always --mounts --git --git-repos'
        abbr --add l exa -al --color=always --group-directories-first --icons=always --mounts --git --git-repos
    else
        alias ls='exa -a --color=always --group-directories-first --icons'
        abbr --add l exa -al --color=always --group-directories-first --icons
    end

    ### OS SPECIFIC ###
    if test (uname -s) = "Darwin"
        set OS_NAME (sw_vers -productName)
    else
        set OS_NAME (lsb_release -is)
    end    

    # if the variable $CONTAINER_ID exists, the sessions is in a distrobox container
    if test -n "$CONTAINER_ID"
        set -e SESSION_MANAGER
        # check if we're in the right home directory
        test (pwd) != $HOME && cd
    end

    switch $OS_NAME
        case "Ubuntu"
            abbr --add ca batcat --color=always	        
            alias cat='batcat -p --color=always'
            abbr --add upd "sudo apt update && sudo apt upgrade -y"
        case "Arch"
            abbr --add ca bat --color=always
            alias cat='bat -p --color=always'
            # pacman and yay
            alias pacsyu='sudo pacman -Syu'      # update only standard pkgs
            alias pacsyyu='sudo pacman -Syyu'    # Refresh pkglist & update standard pkgs
            alias parsua='paru -Sua --noconfirm' # update only AUR pkgs (paru)
            alias parsyu='paru -Syu --noconfirm' # update standard pkgs and AUR pkgs (paru)
            alias unlock='sudo rm /var/lib/pacman/db.lck'   # remove pacman lock
            alias orphan='sudo pacman -Rns (pacman -Qtdq)'  # remove orphaned packages (DANGEROUS!)

            # get fastest mirrors
            alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
            alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
            alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
            alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

        case "Fedora"
            alias dmenu='wofi --dmenu'
            abbr --add vi "nvim"
            abbr --add upd "sudo dnf upgrade"

            # Launch hyprland automatically
            if test (tty) = "/dev/tty1"
                exec Hyprland
            end

        case "macOS"
            abbr --add ca bat --color=always
            alias cat='bat -p --color=always'
        case "Linuxmint"
	        abbr --add ca batcat --color=always
            alias cat='batcat -p --color=always'
            abbr --add upd "sudo apt update && sudo apt upgrade -y"
	case '*'
            echo "CANNOT DETECT OS, CHECK fish.config FILE"
    end
end

