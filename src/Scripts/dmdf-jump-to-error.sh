#/bin/bash
source dmdf-init
# TODO should open vi at last jasshelper error by parsing "$JASSHELPER_PATH"/logs/compileerrors.txt
"$EDITOR" +"$1" "$JASSHELPER_PATH"/logs/currentmapscript.j
