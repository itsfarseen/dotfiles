#!/usr/bin/env bash

# Fix GTK Slow Launch
# Issue: 
# Sway doesn't set DesktopNames=sway in /usr/share/wayland-sessions/sway.desktop
# Without this, gdm sets XDG_CURRENT_DESKTOP=gnome when launching a sway session.
# This causes xdg-desktop-portal.service to fail because it's trying to start xdg-desktop-portal-gnome instead of xdg-desktop-portal-wlr
# This causes some apps to wait for 20s for the portal to start
export XDG_CURRENT_DESKTOP=sway
systemctl --user import-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP
dbus-update-activation-environment --systemd DISPLAY WAYLAND_DISPLAY SWAYSOCK XDG_CURRENT_DESKTOP

blueman-applet &
cbatticon &
gnome-keyring-daemon &
nm-applet &
pasystray &
xsettingsd &
foot --server &
/usr/lib/lxpolkit/lxpolkit & 
waybar &
