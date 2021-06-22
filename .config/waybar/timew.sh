#! /bin/bash
task=$(timew | grep Tracking | cut -d " " -f 2,3)
if [ ! -z ${task+x} ]; then
	class="running"
else
	class="stopped"
fi
printf '{"text": "%s", "alt": "%s", "class": "%s"}\n' "$task" "$class" "$class"
