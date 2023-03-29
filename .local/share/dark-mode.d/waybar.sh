#!/bin/bash

pkill -x waybar
swaymsg "exec waybar --style $HOME/.config/waybar/style_dark.css"
