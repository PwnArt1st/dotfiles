#! /bin/bash

trap 'jobs -p | xargs kill' EXIT

swaymsg -t subscribe -m '["window"]' | jq -r --unbuffered '.container.name | .[0:30]' 
