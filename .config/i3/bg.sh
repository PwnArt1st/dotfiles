#!/bin/bash
bgdir="$HOME/Pictures/Desktop"

source "$HOME/.fehbg"

while true; do
	sleep 60m
	betterlockscreen -u "$bgdir"
	betterlockscreen -w
	#feh --bg-fill --recursive --random $bgdir
done
