# Extract all map files:
cd "$WORKSPACE"
INPUT_DIR="/mnt/ntfs/Projekte/dmdf/archive/ReplaceableTextures/CommandButtons/"
tar --extract --file=dmdf.tar "src/Scripts/"
# TODO use a tool from wc3lib to generate PNG files etc.