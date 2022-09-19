#!/usr/bin/env bash

cd $(dirname $0)

cp ./etc/30-touchpad-libinput.conf /etc/X11/xorg.conf.d/30-touchpad-libinput.conf
