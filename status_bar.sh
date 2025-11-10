#!/bin/sh

# Status Bar
while true; do
    BAT=""
    [ -e /sys/class/power_supply/*/capacity ] && BAT="Bat: $(cat /sys/class/power_supply/*/capacity) |"
    xsetroot -name "$BAT $( date +"%F %R" )"
    sleep 1m
done &