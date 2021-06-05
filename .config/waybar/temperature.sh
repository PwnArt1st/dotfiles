#! /bin/bash

input=$1
temp_long=$(cat "$input")
temp=$(expr "$temp_long" / 1000)
if (( temp  < 20 )); then
    class="idle"
elif (( temp < 45)); then
    class="default"
elif (( temp < 60 )); then
    class="good"
elif (( temp < 80)); then
    class="info"
else
    class="warning"
fi
printf '{"text": "%s", "class": "%s" }\n' "$temp" "$class" 
