#!/bin/bash
bgdir="$HOME/Pictures/Desktop"

while true; do
	bgn="$(ls $bgdir | shuf -n 1)"
	img="$bgdir/$bgn"
	
	swaybg -i $img &
	nextpid=$!
	if [ -n "$oldpid" ]; then kill $oldpid; fi
	oldpid=$nextpid
	rm "$HOME/.config/swaylock/bg"
	ln -s "$img" "$HOME/.config/swaylock/bg"
	sleep 60m
done
