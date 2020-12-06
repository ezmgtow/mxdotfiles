#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use 
# polybar-msg cmd quit

# Wait until the processes have been shut down
#while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar1 and bar2
#echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
#polybar bar1 >>/tmp/polybar1.log 2>&1 &
#polybar bar2 >>/tmp/polybar2.log 2>&1 &

# Launch Polybar
polybar base &
#polybar nimbus &

#This is to launch polybar with all connected monitors. Otherwise, just do 'polybar base &' for simple single-monitor use.
#for m in $(polybar --list-monitors | cut -d":" -f1); do
#	MONITOR=$m polybar --reload base &
#	done

#echo "Polybar launched..."
