#!/bin/sh

case $ACTION in
    pressed)
        exit 2
        ;;
    timeout)
        logger "thu_net: long press, login"
        echo 0 > "/sys/class/leds/netgear:green:wps/brightness"
        echo 0 > "/sys/class/leds/netgear:amber:wps/brightness"
        echo timer > "/sys/class/leds/netgear:amber:wps/trigger"
        echo 50 > "/sys/class/leds/netgear:amber:wps/delay_on"
        echo 50 > "/sys/class/leds/netgear:amber:wps/delay_off"

        /root/thu_connect_net.sh login
        echo none > "/sys/class/leds/netgear:amber:wps/trigger"
        /root/thu_led.sh
        ;;
    released)
        if [ $SEEN -lt 2 ]; then
            logger "thu_net: short press, updating status"
            /root/thu_led.sh
        fi
        ;;
esac
