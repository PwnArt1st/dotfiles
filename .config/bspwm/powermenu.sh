#! /bin/sh
case "$1" in
	"logout") bspc quit;;
	"lock") betterlockscreen -l blur --off 300;;
	"shutdown") sudo poweroff;;
	"reboot") sudo reboot;;
    *) exit 1;;
esac
