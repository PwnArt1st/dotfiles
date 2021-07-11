#!/bin/zsh

if [[ $1 == "playpause" ]]; then
	for p in $(playerctl -l); playerctl -p $p play-pause;
fi

if [[ $1 == "next" ]]; then
	for p in $(playerctl -l); playerctl -p $p next;
fi

if [[ $1 == "prev" ]]; then
	for p in $(playerctl -l); playerctl -p $p previous;
fi

if [[ $1 == "stop" ]]; then
	for p in $(playerctl -l); playerctl -p $p stop;
fi

echo $1
