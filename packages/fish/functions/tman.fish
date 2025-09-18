function tman
    if set -q TMUX
        clear
        tmux popup -EB -w '60%' -h '100%' fish -c 'man $argv[1]'
    else
        tmux new-session "clear; tmux set-option -g status off; tmux popup -EB -w '60%' -h '100%' fish -c 'man $argv[1]'"
    end
end
