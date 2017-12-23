#!/bin/bash

source dmdf-init

API_DIR=$DMDF_PATH/doc/api
echo "Clearing old API in directory \"$API_DIR\"".
rm $API_DIR/*.html
echo "Generating new API."
vjassdoc -mlgpsta --nocomments --noparameters --nolocals --nocalls -T "Die Macht des Feuers" -I "$WC3SDK_PATH/src":"$DMDF_PATH/src" -D "$API_DIR" "$WC3SDK_PATH/src/common.j" "$WC3SDK_PATH/src/common.ai" "$WC3SDK_PATH/src/Blizzard.j" "$WC3SDK_PATH/src/Import Asl.j" "$DMDF_PATH/src/Import Dmdf.j"

#vjassdoc -mlgpsta --nocomments --noparameters --nolocals --nocalls -T "Die Macht des Feuers" -I "/mnt/disk/Projekte/wc3sdk/src":"/mnt/disk/Projekte/Die Macht des Feuers/src" -D "/mnt/disk/Projekte/Die Macht des Feuers/doc/api" "/mnt/disk/Projekte/wc3sdk/src/common.j" "/mnt/disk/Projekte/wc3sdk/src/common.ai" "/mnt/disk/Projekte/wc3sdk/src/Blizzard.j" "/mnt/disk/Projekte/wc3sdk/src/Import Asl.j" "/mnt/disk/Projekte/Die Macht des Feuers/src/Import Dmdf.j"