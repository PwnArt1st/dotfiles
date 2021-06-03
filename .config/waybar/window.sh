#! /bin/bash

swaymsg -t subscribe -m '["window"]' | jq -r --unbuffered '.container.name | .[0:30]'
