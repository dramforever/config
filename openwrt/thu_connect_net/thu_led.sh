#!/bin/sh

status="$("$(dirname "$0")/thu_connect_net.sh" info)"
if [ "$status" == "online" ]; then
    green=255
    amber=0
else
    green=0
    amber=255
fi
echo $green > "/sys/class/leds/netgear:green:wps/brightness"
echo $amber > "/sys/class/leds/netgear:amber:wps/brightness"
