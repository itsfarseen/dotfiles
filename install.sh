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


