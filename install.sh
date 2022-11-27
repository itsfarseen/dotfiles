#!/usr/bin/env bash

cd $(dirname $0)

./home/install.sh

for i in ./config/*; do
	target=$HOME/.config/$(basename $i);
	if [ -d "$target" ] && [ ! -L "$target" ]; then
		echo "Warning: $target exists".
		echo "Remove it and run install.sh again to copy this folder.";
	else
		ln -nsf $(realpath $i) $HOME/.config/$(basename $i);
	fi;
done;

for i in ./share/*; do
	ln -nsf $(realpath $i) $HOME/.local/share/$(basename $i);
done;

mkdir -p $HOME/.local/bin
for i in ./bin/*; do
	ln -nsf $(realpath $i) $HOME/.local/bin/$(basename $i);
done;


