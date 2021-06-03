#!/bin/bash

function main() {
    action=$1
    if [ "${action}" == "up" ]; then
        pactl set-sink-volume @DEFAULT_SINK@ +2%
    elif [ "${action}" == "down" ]; then
        pactl set-sink-volume @DEFAULT_SINK@ -2%
    elif [ "${action}" == "mute" ]; then
        pactl set-sink-mute @DEFAULT_SINK@ toggle
    else
        while true; do
            cur_sink_name=$(pactl info | grep "Default Sink" | cut -d" " -f3)
            sinks=$(pactl list sinks)
            volume=$(echo "$sinks" | grep -A 15 -i "$cur_sink_name" | grep -i "volume" | awk -F : '{print $3; exit}' | grep -o -P '.{0,3}%' | sed 's/.$//' | tr -d ' ' )
            muted=$(echo "$sinks" | grep -A 15 -i "$cur_sink_name" | awk '/Mute/ {print $2; exit}')

            if [[ ${cur_sink_name} == "alsa_output.pci-0000_00_1b.0.analog-stereo" ]]; then
                name="analog"
            elif [[ ${cur_sink_name} == "alsa_output.pci-0000_00_1b.0.iec958-stereo" ]]; then
                name="digital"
            elif [[ ${cur_sink_name} == "bluez_output.CC_98_8B_80_7B_CC.a2dp-sink" ]];then
                name="bluetooth"
            else
                name=${cur_sink_name}
            fi
            
            if [ "$muted" == "yes" ]; then
                class="muted"
                alt="muted"
            else
                class="playing"
                alt="playing"
            fi
            output="on $name"
            printf '{"text": "%s", "class": "%s", "percentage": %d, "alt": "%s"}\n' "$output" "$class" "$volume" "$alt"
            sleep 0.2
        done
    fi
}

main "$@"
