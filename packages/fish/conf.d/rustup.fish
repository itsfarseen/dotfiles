test -f "$HOME/.cargo/env.fish"
  and source "$HOME/.cargo/env.fish"

test (uname) = Darwin
  and test -d /opt/homebrew/opt/rustup/bin
  and fish_add_path /opt/homebrew/opt/rustup/bin
