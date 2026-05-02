#!/bin/bash
PERCENTAGE=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

case ${PERCENTAGE} in
  9[0-9]|100) ICON="█" ;;
  8[0-9])     ICON="▇" ;;
  7[0-9])     ICON="▆" ;;
  6[0-9])     ICON="▅" ;;
  5[0-9])     ICON="▄" ;;
  4[0-9])     ICON="▃" ;;
  3[0-9])     ICON="▂" ;;
  *)          ICON="▁" ;;
esac

if [ "$CHARGING" != "" ]; then
  LABEL="$ICON ${PERCENTAGE}% +"
else
  LABEL="$ICON ${PERCENTAGE}%"
fi

sketchybar --set battery label="$LABEL"
