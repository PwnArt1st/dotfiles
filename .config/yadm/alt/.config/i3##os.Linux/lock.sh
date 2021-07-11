#!/usr/bin/env bash

# Only exported variables can be used within the timer's command.
export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

# Run xidlehook
xidlehook \
  --not-when-fullscreen \
  --not-when-audio \
  --timer 180 \
    'redshift -g .5 -o' \
    'redshift -x' \
  --timer 60 \
    'redshift -g 1 -o; betterlockscreen -l blur --off 300' \
    'redshift -x'
