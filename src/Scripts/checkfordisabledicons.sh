#!/bin/bash

for f in "/cygdrive/e/Projekte/dmdf/archive/ReplaceableTextures/CommandButtons/"BTN* ; do
	disabledIcon="/cygdrive/e/Projekte/dmdf/archive/ReplaceableTextures/CommandButtonsDisabled/DIS$(basename $f)"
	if [ ! -f "$disabledIcon" ] ; then
		echo "Missing disabled icon for: $f"
		echo "Should be: $disabledIcon"
	fi
done