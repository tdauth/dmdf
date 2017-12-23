#!/bin/bash
# Validates the object data of The Power of Fire.

# wc3lib
echo "Workspace: $WORKSPACE"

if [ -d ./wc3lib ] ; then
	rm -rf ./wc3lib
fi

mkdir ./wc3lib
cd ./wc3lib
rpm2cpio ../pkg/wc3lib-0.1.0-Linux.rpm | cpio -idmv

# Extract all map files:
cd "$WORKSPACE"
tar --extract --file=dmdf.tar "maps"

export LD_LIBRARY_PATH="LD_LIBRARY_PATH:$WORKSPACE/wc3lib/usr/lib"

# Validate the object data with the strings of the map Talras for both languages. Check all tooltip references.
cd "$WORKSPACE/maps/"
"$WORKSPACE/wc3lib/usr/bin/wc3objectvalidate" "/mnt/ntfs/Warcraft III" ./Talras/war3map_de.wts ObjectData.w3o
"$WORKSPACE/wc3lib/usr/bin/wc3objectvalidate" "/mnt/ntfs/Warcraft III" ./Talras/war3map_en.wts ObjectData.w3o