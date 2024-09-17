# Don't use set -U here
# set -U stores the actual value of $HOME in the fish_variables file
# which is tracked in the dotfiles repo.
# This makes it non-portable.
if test -z "$XDG_DATA_HOME"
    set -U Z_DATA "$HOME/.local/share/z/data"
else
    set -U Z_DATA "$XDG_DATA_HOME/z/data"
end
set -xp Z_EXCLUDE $HOME
