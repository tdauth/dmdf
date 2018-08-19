#!/bin/bash
# Extracts the German war3map.wts files from all maps and generates the English war3map.wts files based on the English translation of the map Talras.

set -e

cd ../../../
WORKSPACE=$(pwd)

# wc3lib
cd "$WORKSPACE"
echo "Workspace: $WORKSPACE"

if [ -d ./wc3lib ] ; then
	rm -rf ./wc3lib
fi

git clone https://github.com/tdauth/wc3lib.git
cd ./wc3lib
mkdir ./build
cd ./build
cmake .. -DEDITOR=0 -DUSE_KIOSLAVE=0 -DUSE_QBLP=0 -DUSE_OGREBLP=0 -DUSE_MIME=0 -DCMAKE_BUILD_TYPE=Release
make

# Extract all map files:
cd "$WORKSPACE"

mkdir -p "$WORKSPACE/Talras"
mkdir -p "$WORKSPACE/Arena"
mkdir -p "$WORKSPACE/Dornheim"
mkdir -p "$WORKSPACE/Gardonar"
mkdir -p "$WORKSPACE/GardonarsHell"
mkdir -p "$WORKSPACE/Holzbruck"
mkdir -p "$WORKSPACE/HolzbrucksUnderworld"
mkdir -p "$WORKSPACE/Deranor"
mkdir -p "$WORKSPACE/TheNorth"
mkdir -p "$WORKSPACE/WorldMap"
mkdir -p "$WORKSPACE/Credits"

MPQ_PATH="$WORKSPACE/wc3lib/build/src/app/mpq"

# Extract the translated current original war3map.wts files.
cd "$WORKSPACE/maps/Talras"
"$MPQ_PATH" -x -f "war3map.wts" "../Karte 1 - Talras.w3x"
cp -f "./Karte 1 - Talras/war3map.wts" "$WORKSPACE/Talras/war3map_de.wts"

# Arena
cd "$WORKSPACE/maps/Arena"
"$MPQ_PATH" -x -f "war3map.wts" "../Arena.w3x"
cp -f "./Arena/war3map.wts" "$WORKSPACE/Arena/war3map_de.wts"
cp -f "./Arena/war3map.wts" "$WORKSPACE/Arena/war3map_en.wts" # Use a new clean translation
#cp -f "./war3map_en.wts" "$WORKSPACE/Arena/war3map_en.wts"

# Dornheim
cd "$WORKSPACE/maps/Dornheim"
"$MPQ_PATH" -x -f "war3map.wts" "../Tutorial.w3x"
cp -f "./Dornheim/war3map.wts" "$WORKSPACE/Dornheim/war3map_de.wts"
cp -f "./Dornheim/war3map.wts" "$WORKSPACE/Dornheim/war3map_en.wts" # TODO add an initial English translation!

# Gardonar
cd "$WORKSPACE/maps/Gardonar"
"$MPQ_PATH" -x -f "war3map.wts" "../Karte 2 - Gardonar.w3x"
cp -f "./Karte 2 - Gardonar/war3map.wts" "$WORKSPACE/Gardonar/war3map_de.wts"
cp -f "./Karte 2 - Gardonar/war3map.wts" "$WORKSPACE/Gardonar/war3map_en.wts" # TODO add an initial English translation!

# Gardonar's Hell
cd "$WORKSPACE/maps/GardonarsHell"
"$MPQ_PATH" -x -f "war3map.wts" "../Karte 2.1 - Gardonars Unterwelt.w3x"
cp -f "./Karte 2.1 - Gardonars Unterwelt/war3map.wts" "$WORKSPACE/GardonarsHell/war3map_de.wts"
cp -f "./Karte 2.1 - Gardonars Unterwelt/war3map.wts" "$WORKSPACE/GardonarsHell/war3map_en.wts" # TODO add an initial English translation!

# Holzbruck
cd "$WORKSPACE/maps/Holzbruck"
"$MPQ_PATH" -x -f "war3map.wts" "../Karte 3 - Holzbruck.w3x"
cp -f "./Karte 3 - Holzbruck/war3map.wts" "$WORKSPACE/Holzbruck/war3map_de.wts"
cp -f "./Karte 3 - Holzbruck/war3map.wts" "$WORKSPACE/Holzbruck/war3map_en.wts" # TODO add an initial English translation!

# Holzbruck's Underworld
cd "$WORKSPACE/maps/HolzbrucksUnderworld"
"$MPQ_PATH" -x -f "war3map.wts" "../Karte 3.1 - Holzbrucks Unterwelt.w3x"
cp -f "./Karte 3.1 - Holzbrucks Unterwelt/war3map.wts" "$WORKSPACE/HolzbrucksUnderworld/war3map_de.wts"
cp -f "./Karte 3.1 - Holzbrucks Unterwelt/war3map.wts" "$WORKSPACE/HolzbrucksUnderworld/war3map_en.wts" # TODO add an initial English translation!

# Deranor
cd "$WORKSPACE/maps/Deranor"
"$MPQ_PATH" -x -f "war3map.wts" "../Karte 5 - Deranor.w3x"
cp -f "./Karte 5 - Deranor/war3map.wts" "$WORKSPACE/Deranor/war3map_de.wts"
cp -f "./Karte 5 - Deranor/war3map.wts" "$WORKSPACE/Deranor/war3map_en.wts" # TODO add an initial English translation!

# The North
cd "$WORKSPACE/maps/TheNorth"
"$MPQ_PATH" -x -f "war3map.wts" "../TheNorth.w3x"
cp -f "./TheNorth/war3map.wts" "$WORKSPACE/TheNorth/war3map_de.wts"
cp -f "./TheNorth/war3map.wts" "$WORKSPACE/TheNorth/war3map_en.wts" # TODO add an initial English translation!

# World Map
cd "$WORKSPACE/maps/WorldMap"
"$MPQ_PATH" -x -f "war3map.wts" "../WorldMap.w3x"
cp -f "./WorldMap/war3map.wts" "$WORKSPACE/WorldMap/war3map_de.wts"
cp -f "./WorldMap/war3map.wts" "$WORKSPACE/WorldMap/war3map_en.wts" # TODO add an initial English translation!

# Credits
cd "$WORKSPACE/maps/Credits"
"$MPQ_PATH" -x -f "war3map.wts" "../Credits.w3x"
cp -f "./Credits/war3map.wts" "$WORKSPACE/Credits/war3map_de.wts"
cp -f "./Credits/war3map.wts" "$WORKSPACE/Credits/war3map_en.wts" # TODO add an initial English translation!

# Change back to workspace dir.
cd "$WORKSPACE"

# Now generate new English translated files.
WC3_TRANS_PATH="$WORKSPACE/wc3lib/build/src/app/wc3trans"

# Check the original source:
"$WC3_TRANS_PATH" --update --suggest "$WORKSPACE/Talras/war3map_de.wts" ./maps/Talras/war3map_en.wts ./maps/Talras/war3map_en.wts "$WORKSPACE/Talras/war3map_en.wts" &> "$WORKSPACE/Talras/log.txt"

# Now update the other files by the original source:

# Arena
"$WC3_TRANS_PATH" --update "$WORKSPACE/Arena/war3map_de.wts" "$WORKSPACE/Arena/war3map_en.wts" "$WORKSPACE/Arena/war3map_en.wts" "$WORKSPACE/Arena/war3map_en.wts"
"$WC3_TRANS_PATH" "$WORKSPACE/Talras/war3map_de.wts" "$WORKSPACE/Talras/war3map_en.wts" "$WORKSPACE/Arena/war3map_en.wts" "$WORKSPACE/Arena/war3map_en.wts"

# Tutorial
"$WC3_TRANS_PATH" --update "$WORKSPACE/Tutorial/war3map_de.wts" "$WORKSPACE/Tutorial/war3map_en.wts" "$WORKSPACE/Tutorial/war3map_en.wts" "$WORKSPACE/Tutorial/war3map_en.wts"
"$WC3_TRANS_PATH" "$WORKSPACE/Talras/war3map_de.wts" "$WORKSPACE/Talras/war3map_en.wts" "$WORKSPACE/Tutorial/war3map_en.wts" "$WORKSPACE/Tutorial/war3map_en.wts"

# Gardonar
"$WC3_TRANS_PATH" --update "$WORKSPACE/Gardonar/war3map_de.wts" "$WORKSPACE/Gardonar/war3map_en.wts" "$WORKSPACE/Gardonar/war3map_en.wts" "$WORKSPACE/Gardonar/war3map_en.wts"
"$WC3_TRANS_PATH" "$WORKSPACE/Talras/war3map_de.wts" "$WORKSPACE/Talras/war3map_en.wts" "$WORKSPACE/Gardonar/war3map_en.wts" "$WORKSPACE/Gardonar/war3map_en.wts"

# Gardonar's Hell
"$WC3_TRANS_PATH" --update "$WORKSPACE/GardonarsHell/war3map_de.wts" "$WORKSPACE/GardonarsHell/war3map_en.wts" "$WORKSPACE/GardonarsHell/war3map_en.wts" "$WORKSPACE/GardonarsHell/war3map_en.wts"
"$WC3_TRANS_PATH" "$WORKSPACE/Talras/war3map_de.wts" "$WORKSPACE/Talras/war3map_en.wts" "$WORKSPACE/GardonarsHell/war3map_en.wts" "$WORKSPACE/GardonarsHell/war3map_en.wts"

# Holzbruck
"$WC3_TRANS_PATH" --update "$WORKSPACE/Holzbruck/war3map_de.wts" "$WORKSPACE/Holzbruck/war3map_en.wts" "$WORKSPACE/Holzbruck/war3map_en.wts" "$WORKSPACE/Holzbruck/war3map_en.wts"
"$WC3_TRANS_PATH" "$WORKSPACE/Talras/war3map_de.wts" "$WORKSPACE/Talras/war3map_en.wts" "$WORKSPACE/Holzbruck/war3map_en.wts" "$WORKSPACE/Holzbruck/war3map_en.wts"

# Holzbruck's Underworld
"$WC3_TRANS_PATH" --update "$WORKSPACE/HolzbrucksUnderworld/war3map_de.wts" "$WORKSPACE/HolzbrucksUnderworld/war3map_en.wts" "$WORKSPACE/HolzbrucksUnderworld/war3map_en.wts" "$WORKSPACE/HolzbrucksUnderworld/war3map_en.wts"
"$WC3_TRANS_PATH" "$WORKSPACE/Talras/war3map_de.wts" "$WORKSPACE/Talras/war3map_en.wts" "$WORKSPACE/HolzbrucksUnderworld/war3map_en.wts" "$WORKSPACE/HolzbrucksUnderworld/war3map_en.wts"

# Deranor
"$WC3_TRANS_PATH" --update "$WORKSPACE/Deranor/war3map_de.wts" "$WORKSPACE/Deranor/war3map_en.wts" "$WORKSPACE/Deranor/war3map_en.wts" "$WORKSPACE/Deranor/war3map_en.wts"
"$WC3_TRANS_PATH" "$WORKSPACE/Talras/war3map_de.wts" "$WORKSPACE/Talras/war3map_en.wts" "$WORKSPACE/Deranor/war3map_en.wts" "$WORKSPACE/Deranor/war3map_en.wts"

# The North
"$WC3_TRANS_PATH" --update "$WORKSPACE/TheNorth/war3map_de.wts" "$WORKSPACE/TheNorth/war3map_en.wts" "$WORKSPACE/TheNorth/war3map_en.wts" "$WORKSPACE/TheNorth/war3map_en.wts"
"$WC3_TRANS_PATH" "$WORKSPACE/Talras/war3map_de.wts" "$WORKSPACE/Talras/war3map_en.wts" "$WORKSPACE/TheNorth/war3map_en.wts" "$WORKSPACE/TheNorth/war3map_en.wts"

# World Map
"$WC3_TRANS_PATH" --update "$WORKSPACE/WorldMap/war3map_de.wts" "$WORKSPACE/WorldMap/war3map_en.wts" "$WORKSPACE/WorldMap/war3map_en.wts" "$WORKSPACE/WorldMap/war3map_en.wts"
"$WC3_TRANS_PATH" "$WORKSPACE/Talras/war3map_de.wts" "$WORKSPACE/Talras/war3map_en.wts" "$WORKSPACE/WorldMap/war3map_en.wts" "$WORKSPACE/WorldMap/war3map_en.wts"

# Credits
"$WC3_TRANS_PATH" --update "$WORKSPACE/Credits/war3map_de.wts" "$WORKSPACE/Credits/war3map_en.wts" "$WORKSPACE/Credits/war3map_en.wts" "$WORKSPACE/Credits/war3map_en.wts"
"$WC3_TRANS_PATH" "$WORKSPACE/Talras/war3map_de.wts" "$WORKSPACE/Talras/war3map_en.wts" "$WORKSPACE/Credits/war3map_en.wts" "$WORKSPACE/Credits/war3map_en.wts"