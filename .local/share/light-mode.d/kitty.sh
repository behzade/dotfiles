#!/bin/bash

rm ~/.config/kitty/current-theme.conf
ln -s theme-light.conf ~/.config/kitty/current-theme.conf
pkill -SIGUSR1 kitty
