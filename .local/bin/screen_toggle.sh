#!/usr/bin/env bash
mv_path=/tmp/monitor
if [ ! -f $mv_path ] ; then
    mode=0
else 
    mode=$(cat $mv_path)
fi

if [ $mode -eq 1 ]; then
    swaymsg "output eDP-1 disable"
    echo 0 > $mv_path
else 
    swaymsg "output eDP-1 enable"
    echo 1 > $mv_path
fi
