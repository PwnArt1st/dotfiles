#!/usr/bin/env bash

emoji=$(cut -d ';' -f1 ~/.config/i3/emoji_list | shuf | rofi -dmenu -p '' | sed "s/ .*//")

[ "$emoji" != "" ] || exit
echo "$emoji" | tr -d '\n' | xclip -selection clipboard
