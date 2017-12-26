#!/bin/bash
# This script generates level icons for all specified files.

icons=( "BearForm.tga" "ControlledTimeFlow.tga" )

REPLACEABLETEXUTERS_DIR="$1"
OUTPUT_DIR="$2"

if [ ! -d "$REPLACEABLETEXUTERS_DIR" ] ; then
	echo "Missing input directory $REPLACEABLETEXUTERS_DIR" 1>&2
	exit 1
fi

if [ ! -d "$OUTPUT_DIR" ] ; then
	echo "Missing output directory $OUTPUT_DIR." 1>&2
	exit 1
fi

for icon in ${icons[@]}; do
	bash ./dmdf-grimoire-icon.sh "$REPLACEABLETEXUTERS_DIR/BTN$icon" "$OUTPUT_DIR"
done