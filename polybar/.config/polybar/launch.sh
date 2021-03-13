#!/usr/bin/env bash
# Terminate already running bar instances
killall -q polybar
# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

COUNT=$(ps -ef |grep compton |grep -v "grep" |wc -l)
# echo $COUNT
if [ $COUNT -eq 0 ]; then
  compton -b
fi

for m in $(polybar --list-monitors | cut -d":" -f1); do
	WIRELESS=$(ls /sys/class/net/ | grep ^wl | awk 'NR==1{print $1}') MONITOR=$m polybar  --reload mainbar-i3 &
done

echo "Bars launched..."
