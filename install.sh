#!/bin/bash

KONSOLE_DIR="$HOME/.local/share/konsole"
FLAVORS=("Chocula" "Chocula-Pastel")

##############################	Function definitions:
install_theme(){
	local flavor="${FLAVORS[$1]}"
	printf "Installing %s ... " "$flavor"
	mkdir -p "$KONSOLE_DIR"
	cp "$flavor."* "$KONSOLE_DIR"	# Copy colorscheme and profile to dir
	echo "Done"
}

set_as_default(){
	local config="$HOME/.config/konsolerc"
	local default="$1"

	touch "$config"

	if [[ "$default" == "2" ]];	then
		# Clarify which of the two installed themes to set as default:
		printf "Which variant?\n1) Chocula\n2) Chocula-Pastel\n"
		read -r -p "Enter your selection [1|2]: " default
		((default--))
		[[ "$default" != [0-1] ]] && echo "Invalid selection; exiting" && exit
	fi

	local profile="${FLAVORS[$default]}.profile"
	[[ ! -f $KONSOLE_DIR/$profile ]] && cp "$profile" "$KONSOLE_DIR"

	kwriteconfig5 --file "$config" --group "Desktop Entry" --key DefaultProfile "$profile"
	echo "${FLAVORS[$default]} set as default theme."
}

##############################	Main logic:
[[ $(command -v konsole) == "" ]] && echo "Konsole program not found; exiting" && exit

printf "Available flavors to install:\n1) Chocula\n2) Chocula-Pastel\n3) Both\n"
read -r -p "Enter your selection [1|2|3]: " SELECTION
((SELECTION--))	# Decrement selection to match its FLAVORS array index

case $SELECTION in
	0 | 1)	 install_theme "$SELECTION" ;;
	2)	install_theme '0' && install_theme '1' ;;
	*)	echo "Invalid selection; exiting" && exit
esac

read -r -p "Set as default theme? [y|N] " YN
[[ "$YN" == [yY]* ]] && set_as_default "$SELECTION"
