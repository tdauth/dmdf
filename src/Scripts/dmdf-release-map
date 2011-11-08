#!/bin/bash
source dmdf-init

bash dmdf-compile-script-map

if ask "Continue with optimization?"; then
	exit 0
fi

mapPath="$WC3_PATH/Maps/DMdF/Talras.w3x"
echoStats "Copying and optimizing map \"$MAP_PATH_TALRAS\" into \"$mapPath\"."

if [ -e "$mapPath" ]; then
	if ask "File \"$mapPath\" does already exist. Replace?"; then
		exit 0
	fi
	rm "$mapPath"
fi

wine "$OPT_PATH/VXJWTSOPT.exe" --checkall "$MAP_PATH_TALRAS" --do "$mapPath"