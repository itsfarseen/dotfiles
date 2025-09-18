function tfish
    if set -q TMUX
        clear
        tmux popup -EB -w '60%' -h '100%' fish
    else
	tmux new-session "clear; tmux set-option -g status off; tmux popup -EB -w '60%' -h '100%' fish"
    end
end
