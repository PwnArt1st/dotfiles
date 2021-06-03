#! /bin/bash

while true; do
    window=$(swaymsg -t get_tree | jq -r '.. | (.nodes? // empty)[] | select(.focused==true) | {name} | to_entries | .[] | .value ')
    if [[ "$window" == "1" ]]; then
        window=""
    fi
    printf '%.30s\n' "$window"
    sleep 0.2
done
