#!/bin/bash
source dmdf-init
source dmdf-compile

LOCAL_PATH="/mnt/disk/Noch viel neueres Warcraft 3/Warcraft III"
echo "Local path is located at \"$LOCAL_PATH\"."

bash compileMapTalras && cp $MAP_PATH $LOCAL_PATH