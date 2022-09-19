#!/usr/bin/env bash

cd $(dirname $0)

ln -nsf $(realpath ./bashrc) $HOME/.bashrc
ln -nsf $(realpath ./xprofile) $HOME/.xprofile
ln -nsf $(realpath ./cargo-config.toml) $HOME/.cargo/config.toml
