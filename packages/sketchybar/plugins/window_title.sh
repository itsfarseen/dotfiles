#!/bin/bash
TITLE=$(aerospace list-windows --focused --format "%{window-title}" 2>/dev/null | head -1)
if [ -z "$TITLE" ]; then
  TITLE=""
fi
sketchybar --set window_title label="$TITLE"
