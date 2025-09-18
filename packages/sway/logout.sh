#!/usr/bin/env bash
res=$(echo -e "Cancel\nLogout" | wofi --show dmenu --prompt "Logout?")
if [ "$res" = "Logout" ]; then
	sway exit;
fi;
