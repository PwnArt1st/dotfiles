#!/bin/bash
bgdir="$HOME/Pictures/Desktop"

while true; do
	[ -n "$SWAYSOCK" ]
	bgn="$(ls $bgdir | shuf -n 1)"
	img="$bgdir/$bgn"
	#swaymsg -s $SWAYSOCK output "*" bg "$img" fill
	swaybg -i "$img" -m fill -o "*"
	sleep 60m
done
