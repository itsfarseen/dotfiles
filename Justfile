default: build install

install:
    ./dotfiles.py install

build:
    cd packages/aerospace/plugins/aerospace-tools && go build -o ../aerotools .
    cd packages/tmux/plugins/tmux-tools && go build -o ../tmuxtools .
