#!/bin/bash

# The $SELECTED variable is available for space components and indicates if
# the space invoking this script (with name: $NAME) is currently selected:
# https://felixkratz.github.io/SketchyBar/config/components#space----associate-mission-control-spaces-with-an-item

if [[ $SENDER == "space_change" ]]; then
	if [[ $SELECTED == true ]]; then
		sketchybar --set $NAME icon.color=0xff282930 \
			label.color=0xff282930 \
			background.drawing=on \
			background.color=0xffbd93f9
	else
		sketchybar --set $NAME icon.color=0xffbd93f9 \
			label.color=0xffbd93f9 \
			background.drawing=off
	fi
fi

if [[ $SENDER == "front_app_switched" || $SENDER == "space_windows_change" ]]; then
	# $NAME is "space.$sid"
	sid=$(echo $NAME | cut -d'.' -f2)
	icons=""

	QUERY=$(
		yabai -m query --windows --space $sid |
			jq -r '.[].app'
	)

	for app in $QUERY; do
		icon=$(icons.sh $app)
		icons+="$icon "
	done

	sketchybar --set $NAME label="$icons"
fi
