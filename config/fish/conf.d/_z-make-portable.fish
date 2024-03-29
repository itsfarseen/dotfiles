# Don't use set -U here
# set -U stores the actual value of $HOME in the fish_variables file
# which is tracked in the dotfiles repo.
# This makes it non-portable.
set -x Z_DATA $HOME/.local/share/z/data
set -xp Z_EXCLUDE $HOME
