#! /bin/bash
enable_cam() {
	sudo modprobe -r v4l2loopback
	sudo modprobe v4l2loopback devices=1 card_label="ffmpeg_virtualcam" exclusive_caps=1

	OUTPUT=$(v4l2-ctl --list-devices 2> /dev/null | sed -n "/ffmpeg_virtualcam/{n;p;}" | xargs)
	INPUT=$(v4l2-ctl --list-devices 2> /dev/null | sed -n "/$DEVICE/{n;p;}" | xargs)

	if [[ -z $INPUT ]]; then
		notify-send "No device found with name $DEVICE"
		exit 1
	fi

	v4l2-ctl -d "$INPUT" -c power_line_frequency=1
	v4l2-ctl -d "$INPUT" -c focus_auto=0
	v4l2-ctl -d "$INPUT" -c white_balance_temperature_auto=1
	v4l2-ctl -d "$INPUT" -c exposure_auto=3

	ffmpeg -f video4linux2  -input_format mjpeg -video_size "$RESOLUTION" -framerate "$FRAMERATE" -i "$INPUT" -c:v copy -f v4l2 "$OUTPUT" &> /dev/null &
	echo "$!" > "/tmp/ffmpeg_virtualcam"
	
	notify-send "Enabled virtual webcam output $OUTPUT"
}

disable_cam() {
	FFMPEG=$(cat /tmp/ffmpeg_virtualcam 2> /dev/null)
	MPV=$(cat /tmp/virtualcam_viewer 2> /dev/null)
	# OUTPUT=$(v4l2-ctl --list-devices 2> /dev/null | sed -n '/ffmpeg_virtualcam/{n;p;}'

	if [[ ! -z "$MPV" ]]; then
		kill -s QUIT "$MPV"
		rm /tmp/virtualcam_viewer
		sleep 1
	fi

	if [[ ! -z "$FFMPEG" ]]; then
		kill -s QUIT "$FFMPEG"
		rm /tmp/ffmpeg_virtualcam
		sleep 1
	fi
	
	sudo modprobe -r v4l2loopback
	
	notify-send "Disabled virtual webcam output $OUTPUT"
}

view_cam() {
	OUTPUT=$(v4l2-ctl --list-devices 2> /dev/null | sed -n '/ffmpeg_virtualcam/{n;p;}' | xargs)

	if [[ -z "$OUTPUT" || ! -f "/tmp/ffmpeg_virtualcam" ]]; then
		notify-send "No v4l2loopback output detected. Start it with webcam.sh -e"
		exit 1
	else
		mpv --vf=hflip --profile=low-latency av://v4l2:"$OUTPUT" &
		echo "$!" > /tmp/virtualcam_viewer
		notify-send "Started mpv preview for $OUTPUT"
	fi
}

usage() {
	echo "./webcam.sh [-option] [resolution] [framerate]"
	echo " "
	echo "options:"
	echo "-h			Show brief help"
	echo "-e			Enable the virtual cam"
	echo "-d			Disable the virtual cam"
	echo "-v			View the virtual cam"
	exit 0
}

while getopts "hedv" flag; do
case "$flag" in
	h) usage;;
	e) COMMAND="enable";;
	d) COMMAND="disable";;
	v) COMMAND="view";;
esac
done

shift $(($OPTIND - 1))


RES_REGEX="[[:digit:]]+x[[:digit:]]+"
FPS_REGEX="^([[:digit:]]+)"
DEV_REGEX="[[:graph:]]+"

RESOLUTION="1280x720"
FRAMERATE=30
DEVICE="C920"

while test $# -gt 0; do
	if [[ "$1" =~ $RES_REGEX ]]; then
		RESOLUTION="$1"
		shift
		continue
	fi

	if [[ "$1" =~ $FPS_REGEX ]]; then
		FRAMERATE="$1"
		shift
		continue
	fi

	if [[ "$1" =~ $DEV_REGEX ]]; then
		DEVICE="$1"
		shift
		continue
	fi

	if [[ -z "$1" ]]; then
		break
	fi
done

case $COMMAND in
"enable"*)
	enable_cam
	;;
"disable"*)
	disable_cam
	;;
"view"*)
	view_cam
	;;
esac
