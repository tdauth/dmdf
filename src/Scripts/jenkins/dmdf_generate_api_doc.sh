#!/bin/bash
# Generates an HTML API documentation with vjassdoc.

set -e

cd ../../../
WORKSPACE=$(pwd)

# vjassdoc
cd "$WORKSPACE"
echo "Workspace: $WORKSPACE"

if [ -d ./vjassdoc ] ; then
	rm -rf ./vjassdoc
fi

git clone https://github.com/tdauth/vjassdoc.git
cd ./vjassdoc
mkdir ./build
cd ./build
cmake ..
make

# Extract all map files:
cd "$WORKSPACE"

VJASSDOC_PATH="$WORKSPACE/vjassdoc/build/src/vjassdoc"

mkdir ./api_documentation

"$VJASSDOC_PATH" -lgsva -T "The Power of Fire" -I "$WORKSPACE/src" -D ./html_api_documentation "$WORKSPACE/src/Import Dmdf.j"