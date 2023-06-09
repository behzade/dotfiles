#!/bin/bash

rm ~/.config/kitty/current-theme.conf
ln -s ~/.config/kitty/theme-dark.conf ~/.config/kitty/current-theme.conf
pkill -SIGUSR1 kitty
