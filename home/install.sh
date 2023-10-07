#!/usr/bin/env bash

cd $(dirname $0)

ln -nsf $(realpath ./bashrc) $HOME/.bashrc
ln -nsf $(realpath ./bash_profile) $HOME/.bash_profile
ln -nsf $(realpath ./xprofile) $HOME/.xprofile
mkdir -p $HOME/.cargo
ln -nsf $(realpath ./cargo-config.toml) $HOME/.cargo/config.toml
