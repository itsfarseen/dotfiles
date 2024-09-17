# Don't use set -U here
# set -U stores the actual value of $HOME in the fish_variables file
# which is tracked in the dotfiles repo.
# This makes it non-portable.
if test -z "$XDG_DATA_HOME"
    set -U Z_DATA_DIR "$HOME/.local/share/z"
else
    set -U Z_DATA_DIR "$XDG_DATA_HOME/z"
end
set -U Z_DATA "$Z_DATA_DIR/data"

set -xp Z_EXCLUDE $HOME
