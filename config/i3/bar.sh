#!/bin/bash

. ~/.cache/wal/colors.sh

Clock() {
	DATETIME=$(date "+%a %b %d, %T")

	echo -n "$DATETIME"
}

Wifi() {
	wifi=$(nmcli device wifi | grep -e '^\*' | awk '{getline; print}')
	name=$(echo "$wifi" | awk '{print $2}')
	bars=$(echo "$wifi" | awk '{print $8}')
	ip=$(hostname -I | cut -d ' ' -f 1-2)

	echo "$name  $bars  $ip"
}

Battery() {
	BATPERC=$(acpi -b | cut -d, -f2)

	for d in $BATPERC; do
		d=$(echo $d | sed 's/\%//')
		total=$((d + total))
	done
	total="$((total / 2))"

	symbol=""
	if [[ $total -gt 74 ]]; then
		symbol=""
	elif [[ $total -gt 49 && $total -lt 75 ]]; then
		symbol=""
	elif [[ $total -gt 24 && $total -lt 50 ]]; then
		symbol=""
	else
		symbol=""
	fi

	bat1=$(echo $BATPERC | head -n1)
	bat1=$(echo $bat1 | sed 's/ /, /')
	echo "$symbol $bat1 "
}

Window() {
	cur_win=$(xdotool getactivewindow getwindowname)
	echo "$cur_win"
}

Song() {
	status=$(playerctl status)
	if [[ $status == "Playing" ]]; then
		symbol=""
		song=$(playerctl metadata xesam:title)
		artist=$(playerctl metadata xesam:artist)
		echo "$symbol  $song - $artist  |  "
	fi
}

while true; do
	echo "|  $(Window)  |  $(Clock)  |  $(Song)$(Wifi)  |  $(Battery)"
	sleep 1
done
