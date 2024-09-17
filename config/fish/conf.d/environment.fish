if test -z "$XDG_CONFIG_HOME"
    source $HOME/.config/shell-common/environment
else
    source $XDG_CONFIG_HOME/shell-common/environment
end
