#!/bin/bash

toggle() {
	# Update the value of the setting in the config file
	sed -i "s/^gtk-application-prefer-dark-theme *=.*/gtk-application-prefer-dark-theme=0/" "$CONFIG_FILE"
	sed -i "s/^gtk-theme-name *=.*/gtk-theme-name=Adwaita/" "$CONFIG_FILE"
	sed -i "s/^gtk-cursor-theme-name *=.*/gtk-cursor-theme-name=Adwaita/" "$CONFIG_FILE"
}

toggle "$HOME/.config/gtk-3.0/settings.ini"
toggle "$HOME/.config/gtk-4.0/settings.ini"
