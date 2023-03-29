#!/bin/bash

toggle() {
	# Update the value of the setting in the config file
	sed -i "s/^gtk-application-prefer-dark-theme *=.*/gtk-application-prefer-dark-theme=1/" "$1"
	sed -i "s/^gtk-theme-name *=.*/gtk-theme-name=Adwaita:dark/" "$1"
	sed -i "s/^gtk-cursor-theme-name *=.*/gtk-cursor-theme-name=Adwaita:dark/" "$1"
}

toggle "$HOME/.config/gtk-3.0/settings.ini"
toggle "$HOME/.config/gtk-4.0/settings.ini"
