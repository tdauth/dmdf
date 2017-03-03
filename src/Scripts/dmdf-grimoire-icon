#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]; then
	echo "Usage: $0 <icon file> <output directory>" >&2
	exit 1
fi

if [ ! -e "$1" ]; then
	echo "Input file $1 does not exist." >&2
	exit 1
fi

if [ ! -d "$2" ]; then
	echo "Output directory $2 does not exist." >&2
	exit 1
fi

MAX_LEVELS="6"

#-font dfst-m3u.ttf -pointsize 40 label:"$i"
for ((i=0; i < "$MAX_LEVELS"; i++)) do
	FILE_NAME="$(basename "$1" .tga)"Level$i.png
	OUTPUT_FILE_NAME="$2/$FILE_NAME"
	convert -gravity SouthEast "$1" human-button-lvls-overlay.png -composite -gravity SouthEast -pointsize 18 -fill white -annotate +10+5 $i "$OUTPUT_FILE_NAME"
	convert "$OUTPUT_FILE_NAME" -type Grayscale "$2"/DIS"$FILE_NAME"
done
