#!/usr/bin/bash
(	
	flock 200

	# Terminate already running bar instances
	killall -q polybar

	# Wait until the processes have been shut down
	while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

	outputs=$(xrandr --query | grep " connected" | cut -d" " -f1)
	tray_output=LVDS1

	for m in $outputs; do
		if [[ $m == "LVDS1" ]]; then
			tray_output=$m
		fi
	done

	for m in $outputs; do
		export MONITOR=$m
		export TRAY_POSITION=none
		if [[ $m == $tray_output ]]; then
			TRAY_POSITION=right
		fi

		polybar -c ~/.config/polybar/config.ini --reload main </dev/null >/var/tmp/polybar-$m.log 2>&1 200>&- &
		disown
	done

) 200>/var/tmp/polybar-launch.lock


