#! /bin/sh

wid=$1
class=$2
instance=$3

if [ "$instance" = Steam ] ; then
	title=$(xtitle "$wid")
	case "$title" in
		Friends|Friends List|Steam - News|Steam - Self Updater|Settings|Steam Guard - Computer Authorization)
			echo "state=floating"
			;;
