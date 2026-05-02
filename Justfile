default:
    just build

build:
    cd plugins/aerospace-tools && go build -o ../aerotools .
