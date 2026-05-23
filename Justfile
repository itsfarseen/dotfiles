default:
    just build

build:
    cd packages/aerospace/plugins/aerospace-tools && go build -o ../aerotools .
    cd packages/tmux/plugins/tmux-tools && go build -o ../tmuxtools .
