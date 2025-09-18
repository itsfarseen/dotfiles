if command -v go >/dev/null
    fish_add_path (go env GOPATH)/bin
end
