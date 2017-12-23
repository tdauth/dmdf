#!/bin/bash
source dmdf-init

SCRIPT_PATH=$DMDF_PATH/src/Talras/war3map.j
mapPath="$WC3_PATH/Maps/ASL Test/Asl.w3x"
echo "Compiling map is located at \"$mapPath\"."
cd "$JASSHELPER_PATH"
# --debug
wine "$JASSHELPER_PATH/clijasshelper.exe" --debug "$ASL_PATH/src/common.j" "$ASL_PATH/src/Blizzard.j" "$mapPath"
