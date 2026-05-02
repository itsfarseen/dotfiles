default:
    just build

build:
    cd packages/aerospace/plugins/aerospace-tools && go build -o ../aerotools .
