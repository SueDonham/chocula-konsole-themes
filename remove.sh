#!/bin/bash

[[ $(command -v konsole) == "" ]] && echo "Konsole program not found; exiting" && exit

THEME_DIR="$HOME/.local/share/konsole"
DEFAULT=$(kreadconfig5 --file "$HOME"/.config/konsolerc --group "Desktop Entry" --key DefaultProfile)

printf "Removing theme(s) ... "
for f in "$HOME/.local/share/konsole/Chocula"* ; do  rm "$f" &>/dev/null ; done  # Remove Chocula file(s)

# If Chocula was default profile, reset to built-in:
[[ "$DEFAULT" =~ "Chocula" ]] && kwriteconfig5 --file "$HOME"/.config/konsolerc --group "Desktop Entry" --key DefaultProfile ""

echo "Done."
