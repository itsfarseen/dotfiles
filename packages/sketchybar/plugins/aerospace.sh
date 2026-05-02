#!/bin/bash
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"
SID="${NAME#space.}"  # strips "space." prefix → "1", "2", etc.
NON_EMPTY=$(aerospace list-workspaces --empty no --monitor all)
APPS=$(aerospace list-windows --workspace "$SID" --format '%{app-name}' | paste -sd '·' -)
LABEL="$SID${APPS:+ $APPS}"

# Hide empty workspaces (unless focused)
if echo "$NON_EMPTY" | grep -qw "$SID" || [ "$FOCUSED" = "$SID" ]; then
  DRAWING=on
else
  DRAWING=off
fi

if [ "$FOCUSED" = "$SID" ]; then
  sketchybar --set "$NAME" drawing="$DRAWING" \
                           background.drawing=on \
                           label="$LABEL" \
                           label.color=0xffffffff
else
  sketchybar --set "$NAME" drawing="$DRAWING" \
                           background.drawing=off \
                           label="$LABEL" \
                           label.color=0xffffffff
fi
