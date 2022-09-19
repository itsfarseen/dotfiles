#!/usr/bin/env bash

cd $(dirname $0)

./home/install.sh

for i in ./config/*; do
	ln -nsf $(realpath $i) $HOME/.config/$(basename $i);
done;

for i in ./share/*; do
	ln -nsf $(realpath $i) $HOME/.local/share/$(basename $i);
done;

for i in ./bin/*; do
	ln -nsf $(realpath $i) $HOME/.local/bin/$(basename $i);
done;

mkdir -p $HOME/.config/systemd/user;
for i in ./systemd-user/*; do
	ln -sf $(realpath $i) $HOME/.config/systemd/user/;
done;

for i in ./systemd-user/*.service; do
	systemctl --user enable $(basename $i);
done;

