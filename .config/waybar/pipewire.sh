#!/bin/bash

function main() {
    #DEFAULT_SOURCE=$(pw-record --list-targets | sed -n 's/^*[[:space:]]*[[:digit:]]\+: description="\(.*\)" prio=[[:digit:]]\+$/\1/p')
    DEFAULT_SINK_ID=$(pw-play --list-targets | sed -n 's/^*[[:space:]]*\([[:digit:]]\+\):.*$/\1/p')
    DEFAULT_SINK=$(pw-play --list-targets | sed -n 's/^*[[:space:]]*[[:digit:]]\+: description="\(.*\)" prio=[[:digit:]]\+$/\1/p')
    VOLUME=$(pactl list sinks | sed -n "/Sink #${DEFAULT_SINK_ID}/,/Volume/ s!^[[:space:]]\+Volume:.* \([[:digit:]]\+\)%.*!\1!p" | head -n1)
    IS_MUTED=$(pactl list sinks | sed -n "/Sink #${DEFAULT_SINK_ID}/,/Mute/ s/Mute: \(yes\)/\1/p")

    action=$1
    if [ "${action}" == "up" ]; then
        pactl set-sink-volume @DEFAULT_SINK@ +2%
    elif [ "${action}" == "down" ]; then
        pactl set-sink-volume @DEFAULT_SINK@ -2%
    elif [ "${action}" == "mute" ]; then
        pactl set-sink-mute @DEFAULT_SINK@ toggle
    else
        while true; do
            DEFAULT_SINK=$(pw-play --list-targets | sed -n 's/^*[[:space:]]*[[:digit:]]\+: description="\(.*\)" prio=[[:digit:]]\+$/\1/p')
            VOLUME=$(pactl list sinks | sed -n "/Sink #${DEFAULT_SINK_ID}/,/Volume/ s!^[[:space:]]\+Volume:.* \([[:digit:]]\+\)%.*!\1!p" | head -n1)
            IS_MUTED=$(pactl list sinks | sed -n "/Sink #${DEFAULT_SINK_ID}/,/Mute/ s/Mute: \(yes\)/\1/p")
        
            if [[ ${DEFAULT_SINK} == "Built-in Audio Analog Stereo" ]]; then
                name="analog"
            elif [[ ${DEFAULT_SINK} == "Built-in Audio Digital Stereo (IEC958)" ]]; then
                name="digital"
            elif [[ ${DEFAULT_SINK} == "LE_WH-1000XM3" ]];then
                name="bluetooth"
            else
                name=${DEFAULT_SINK}
            fi
            
            if [ "${IS_MUTED}" != "" ]; then
                class="muted"
                alt="muted"
            else
                class="playing"
                alt="playing"
            fi
            output="on $name"
            printf '{"text": "%s", "class": "%s", "percentage": %d, "alt": "%s"}\n' "$output" "$class" "$VOLUME" "$alt"
            sleep 0.2
        done
    fi
}

main "$@"
