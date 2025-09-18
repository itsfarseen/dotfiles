#!/usr/bin/env bash

# Fix GTK Slow Launch
# Issue: 
# Sway doesn't set DesktopNames=sway in /usr/share/wayland-sessions/sway.desktop
# Without this, gdm sets XDG_CURRENT_DESKTOP=gnome when launching a sway session.
# This causes xdg-desktop-portal.service to fail because it's trying to start xdg-desktop-portal-gnome instead of xdg-desktop-portal-wlr
# This causes some apps to wait for 20s for the portal to start
export XDG_CURRENT_DESKTOP=sway
export QT_QPA_PLATFORMTHEME=qt6ct
systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP

# This is needed because the foot systemd unit won't autostart if the
# WAYLAND_DISPLAY env var is not set. We are setting it above, much later after
# systemd tries autostarting the enabled units.
systemctl --user start foot-server.socket

gnome-keyring-daemon &
#kwalletmanager &
/usr/lib/lxpolkit/lxpolkit & 
xsettingsd &
nwg-panel &
sleep 0.5s
blueman-applet &
nm-applet &
swaync &
# wlr-gammactl-fzn -c 0.97:1.00:0.95 -g 1.015:1.01:1.0 -b 1.01:1.005:0.99
# wlr-gammactl-fzn -c 0.98:1.00:0.94 -g 1.015:1.01:1.0 -b 1.02:1.005:0.98
# wlr-gammactl-fzn -c 1.1:1.1:1.1 -g 1.1:1.1:1.1 -b 0.915:0.915:0.9
# /usr/local/bin/wlr-gammactl-fzn -c 1.01:1.00:0.95 -g 0.95:0.95:0.95 -b 0.97:0.97:0.95
# /usr/local/bin/wlr-gammactl-fzn -c 1.01:1.04:0.86 -b 0.94:0.95:0.88 -g 0.93:0.88:1.10 &
sleep 2s
maestral_qt &
