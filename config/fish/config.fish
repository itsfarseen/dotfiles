if status is-interactive
    # Commands to run in interactive sessions can go here
end

function pacman_correct --argument-names cmdline --on-event fish_postexec
    if test $status -eq 0
        return
    end

    if not command -q pacman
        return
    end

    if string match -q 'sudo pacman -S *' "$cmdline"
        echo
        set search_cmdline $(string replace ' -S ' ' -Ss ' "$cmdline")
        eval "command $search_cmdline"
        echo
        echo "Looks like you were trying to search for a package and it's not found."
        echo "Please see the list of similar packages above."
        echo
    end
end
