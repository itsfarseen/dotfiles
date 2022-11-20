#!/usr/bin/env bash

mkdir -p $HOME/.config/systemd/user;
for i in ./systemd-user/*; do
	ln -sf $(realpath $i) $HOME/.config/systemd/user/;
done;

for i in ./systemd-user/*.service; do
	systemctl --user enable $(basename $i);
done;
