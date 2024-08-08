function fcd
    cd $(find -L $HOME -type d \( -path "$HOME/.steam" -o -path "$HOME/.distrobox" -o -path "$HOME/.local/share/containers" -o -path "$HOME/Android" -o -path "$HOME/.wine" -o -path "$HOME/.git-dotfiles" -o -path "$HOME/go" -o -path "$HOME/.var" -o -path "$HOME/.nv" -o -path "$HOME/.npm" -o -path "$HOME/.cargo" -o -path "$HOME/.mozilla" -o -path "$HOME/Code" -o -path "$HOME/.cache" -o -path "$HOME/.gradle" -o -path "$HOME/.conan2" -o -path "$HOME/.config/vivaldi" -o -path "$HOME/.librewolf" -o -path "$HOME/.config/coc" -o -path "$HOME/.vim" \) -prune -o -type d -name ".git" -prune -o -type d -print |fzf)
    # cd $(find -type d | fzf)
end

