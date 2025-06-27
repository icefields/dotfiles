function pushb
    set branch (git branch --show-current)
    echo "git push -u origin $branch"
    read -l -P "Proceed? [y,N] " confirm
    switch $confirm
        case Y y
            git push -u origin $branch
            return 0
        case '' N n
            return 1
    end
end

