#!/bin/bash
bgdir="$HOME/Pictures/Desktop"

while true; do
	[ -n "$SWAYSOCK" ]
	bgn="$(ls $bgdir | shuf -n 1)"
	img="$bgdir/$bgn"
	swaymsg -s "$SWAYSOCK" output "*" bg "$img" fill
	rm "$HOME/.config/swaylock/bg"
	ln -s "$img" "$HOME/.config/swaylock/bg"
	sleep 60m
done
