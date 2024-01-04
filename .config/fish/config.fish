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
    abbr --add l exa -al --color=always --group-directories-first    
    # git
    abbr --add gcb git checkout -b
    abbr --add gco git checkout   
    abbr --add gp git pull

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

    # git
    alias addup='git add -u'
    alias addall='git add .'
    alias branch='git branch'
    alias checkout='git checkout'
    alias clone='git clone'
    alias commit='git commit -m'
    alias fetch='git fetch'
    alias pull='git pull origin'
    alias push='git push origin'
    alias tag='git tag'
    alias newtag='git tag -a'

    # ps
    alias psa="ps auxf"
    alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
    alias psmem='ps auxf | sort -nr -k 4'
    alias pscpu='ps auxf | sort -nr -k 3'


    # adding flags
    alias df='df -h'                          # human-readable sizes
    alias free='free -m'                      # show sizes in MB

    ### DOT FILES BACKUP, BARE REPO
    alias gitdots='/usr/bin/git --git-dir=$HOME/.git-dotfiles/ --work-tree=$HOME'

    ### OS SPECIFIC ###
    if test (uname -s) = "Darwin"
        set OS_NAME (sw_vers -productName)
    else
        set OS_NAME (lsb_release -is)
    end    
    
    switch $OS_NAME
        case "Ubuntu"
            abbr --add ca batcat	        
            abbr --add upd "sudo apt update && sudo apt upgrade -y"
            set -e SESSION_MANAGER
            cd
        case "Arch"
            abbr --add ca bat
            set -e SESSION_MANAGER
	case "macOS"
            abbr --add ca bat
        case '*'
            echo "CANNOT DETECT OS, CHECK fish.config FILE"
    end

    ### THEME BOBTHEFISH ###
    ### https://github.com/oh-my-fish/theme-bobthefish ###
    set -g theme_nerd_fonts yes
    set -g theme_powerline_fonts yes
    # theme Show full path
    set -g fish_prompt_pwd_dir_length 0
    # Cursor on a new line
    set -g theme_newline_cursor no
    # display "arch", "ubuntu" etc
    set -g theme_display_hostname yes
    # date prompt
    set -g theme_date_format "+%H:%M %a %h %d"

    ### THEME BUDSPENCER ###
    set -U budspencer_nobell
end
