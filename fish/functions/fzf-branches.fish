function fzf-branches \
    -w "git branch" \
    -d "Select a branch using fzf"

    set branches (git for-each-ref refs/heads refs/remotes --sort=-committerdate --color=always --format='%(refname:short) %(color:green)%(committerdate:relative) %(color:blue)%(subject) %(color:magenta)%(authorname)%(color:reset)')

    # if there are no branches, return nothing
    if not count $branches > /dev/null
        return 1
    end

    # if arguments are passed to the function,
    # pass them to fzf as a query
    if count $argv > /dev/null
        set selected (
            for b in $branches; echo $b; end \
            | fzf --multi --ansi --select-1 --exit-0 --query="$argv"
        )
    else
        set selected (
            for b in $branches; echo $b; end \
            | fzf --multi --ansi
        )
    end

    if test $status -eq 130
        # fzf cancelled
        return 130
    end

    if not count $selected > /dev/null
        # nothing selected
        return
    end

    for s in $selected
        echo $s
    end
end

