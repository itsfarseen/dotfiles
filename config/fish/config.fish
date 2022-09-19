# Aliases
alias cdg 'cd $(git rev-parse --show-toplevel)'
alias dcd 'docker-compose down'
alias dcdu 'dcd && dcu'
alias dcduf 'dcd && dcuf'
alias dcl 'docker-compose logs'
alias dclf 'docker-compose logs -f'
alias dcu 'docker-compose up -d'
alias dcuf 'docker-compose up'
alias dps 'docker ps'
alias gc 'git commit'
alias gce 'git commit --amend'
alias gcev 'git commit --amend -v'
alias gcv 'git commit -v'
alias gd 'git diff'
alias gds 'git diff --staged'
alias gl 'git log --graph --oneline'
alias gla 'git log --graph --oneline --all'
alias glg 'git log'
alias gpl 'git pull'
alias gps 'git push'
alias gpsf 'git push -f'
alias gr 'git rebase'
alias gra 'git rebase --abort'
alias grc 'git rebase --continue'
alias gri 'git rebase -i'
alias grs 'git rebase --skip'
alias gs 'gst'
alias gst 'git status'
alias hms 'home-manager switch'
alias nxs 'nix search nixpkgs'
alias nxsw 'sudo nixos-rebuild switch'
alias vim 'nvim'
alias zb 'z -b'
alias zc 'z -c'
alias zt 'z -t'

direnv hook fish | source
lua /usr/share/z.lua/z.lua --init fish | source
starship init fish | source

export PATH="$HOME/.local/share/solana/install/active_release/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'
