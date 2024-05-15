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
    abbr --add ad git add .
    abbr --add pus git push -u origin 
    abbr --add pum git push -u origin main 
    abbr --add pud git push -u origin dev 
    abbr --add com git commit -m \"
    abbr --add chb git checkout -b
    abbr --add che git checkout   
    abbr --add pul git pull
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

    alias getpath="find -type f | fzf | sed 's/^..//' | tr -d '\n' | xclip -selection c"

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
            # to work with distrobox
            set -e SESSION_MANAGER
            cd
        case "Arch"
            abbr --add ca bat
            # to work with distrobox
            set -e SESSION_MANAGER
	case "macOS"
            abbr --add ca bat
        case "Linuxmint"
	    abbr --add ca batcat 
            abbr --add upd "sudo apt update && sudo apt upgrade -y"
	case '*'
            echo "CANNOT DETECT OS, CHECK fish.config FILE"
    end

    ### THEME BOBTHEFISH ###
    ### https://github.com/oh-my-fish/theme-bobthefish ###
    set -g theme_color_scheme terminal-dark
    set -g theme_show_project_parent no
    set -g theme_nerd_fonts yes
    set -g theme_powerline_fonts yes
    # theme Show full path
    set -g fish_prompt_pwd_dir_length 0
    # Cursor on a new line
    set -g theme_newline_cursor yes
    # newline prompt
    set -g theme_newline_prompt "   " #  " #   "  " #   #  " #  
    # display "arch", "ubuntu" etc
    set -g theme_display_hostname yes
    # date prompt
    set -g theme_date_format "+%H:%M %a %h %d"
    # show any non-zero exit code next to the exclamation mark.
    set -g theme_show_exit_status yes
    # display the number of currently running background jobs next to the percent sign
    set -g theme_display_jobs_verbose yes
    ### THEME BUDSPENCER ###
    set -U budspencer_nobell
end
