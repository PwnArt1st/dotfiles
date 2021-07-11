#! /bin/bash
task=$(timew | grep Tracking | cut -d " " -f 2,3)
time=$(timew | grep Total | cut -d " " -f 18)
if [ ${#task} -ge 1 ]; then
	class="running"
else
	class="stopped"
fi
printf '{"text": "%s", "alt": "%s", "tooltip": "%s", "class": "%s"}\n' "$task" "$class" "$time" "$class"
