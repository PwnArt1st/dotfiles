#!/bin/bash

function get_screen() {
	MONITORS=$(xrandr | grep -o '[0-9]*x[0-9]*[+-][0-9]*[+-][0-9]*')
	# Get the location of the mouse
	XMOUSE=$(xdotool getmouselocation | awk -F "[: ]" '{print $2}')
	YMOUSE=$(xdotool getmouselocation | awk -F "[: ]" '{print $4}')
	
	for mon in ${MONITORS}; do
	  # Parse the geometry of the monitor
	  MONW=$(echo ${mon} | awk -F "[x+]" '{print $1}')
	  MONH=$(echo ${mon} | awk -F "[x+]" '{print $2}')
	  MONX=$(echo ${mon} | awk -F "[x+]" '{print $3}')
	  MONY=$(echo ${mon} | awk -F "[x+]" '{print $4}')
	  # Use a simple collision check
	  if (( ${XMOUSE} >= ${MONX} )); then
	    if (( ${XMOUSE} <= ${MONX}+${MONW} )); then
	      if (( ${YMOUSE} >= ${MONY} )); then
	        if (( ${YMOUSE} <= ${MONY}+${MONH} )); then
	          # We have found our monitor!
	          #maim -g"${MONW}x${MONH}+${MONX}+${MONY}" someplace.png
	          echo "${MONW}x${MONH}+${MONX}+${MONY}"
	          exit 0
	        fi
	      fi
	    fi
	  fi
	done
	echo "Oh no the mouse is in the void!"
	exit 1
}

while test $# -gt 0; do
        case "$1" in
                -h|--help)
                        echo "./screenshot [-option]"
                        echo " "
                        echo "options:"
                        echo "-h, --help                show brief help"
                        echo "-c       					Copy image to clipboard"
                        echo "-s       					Select area to grab"
                        exit 0
                        ;;
                -c)
                        shift
	 					export CLIP=1
                        shift
                        ;;
                -s)
                        shift
                        export SELECT=1
                        shift
                        ;;
                -sc|-cs)
                        shift
                        export CLIP=1
                        export SELECT=1
                        shift
                        ;;
                *)
                        break
                        ;;
        esac
done
if [[ $SELECT == 1 ]]; then
	if [[ $CLIP == 1 ]]; then
		maim -s -u | xclip -selection clipboard -t image/png
	else
		maim -s -u ~/Pictures/Screenshots/$(date +%s).png
	fi
else
	if [[ $CLIP == 1 ]]; then
		maim -g $(get_screen) | xclip -selection clipboard -t image/png
	else
		maim -g $(get_screen) ~/Pictures/Screenshots/$(date +%s).png
	fi
fi
