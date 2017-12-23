#!/bin/bash
# At the moment this script is supposed to create a replacement of War3Patch.mpq with all DMdF files since we cannot use JNGP on GNU/Linux
source dmdf-init

realPath="$WC3_PATH/War3Patch.mpq"
path="$realPath"
backupPath="$WC3_PATH/War3Patchecht.mpq"

# if there is a backup file we're going to use it since it is the original patch archive
if [ ! -e "$path" ] || [ -e "$backupPath" ]; then
	echoStats "Using backup file \"$backupPath\"."
	path="$backupPath"
fi

# in this case there is no archive at all
if [ ! -e "$path" ]; then
	echoError "Missing patch archive \"$path\" or \"$realPath\"."
	exit 1
fi

mkdir tmp
cd tmp
# extract all original patch files
smpq -L ~/Dokumente/Projekte/wc3tools/mpqmaster/Listfiles/Warcraft\ III.txt -x "$path"

# remove old archive if tmp directory wasn't deleted properly
if [ -e War3Patch.mpq ]; then
	echo "Removing old War3Patch.mpq."
	rm War3Patch.mpq
fi

# sync all DMdF files to the tmp directory
rsync -av "$DMDF_PATH/archives/DMdF/"* .
rsync -av "$DMDF_PATH/archives/DE"/* .

format()
{
	while read line ; do
		echo "\"${line:2}\"" # skip ./ chars and escape argument
	done

	return 0
}

# use this for debugging
#find . -type f | format | xargs echo >> tmpArguments
#find . -type f | format | xargs smpq -cA -m autodetect -M 1 War3Patch.mpq
find . -type f | format >> tmpArguments
number=$(wc -l tmpArguments | cut -d' ' -f1)
echoStats "Found $number file paths."
# FIXME head -n 1 is required since smpq needs at least one file path to create an archive
# FIXME we cannot pass everything on creation since xargs seems to start multiple processes because the number of arguments is too high
# if smpq supports passing lists or directories instead of single paths use it rather than calling several processes which have to rebuild the hash table
head -n 1 tmpArguments | xargs smpq -cA -m "$number" -M 1 War3Patch.mpq
cat tmpArguments | xargs smpq -a War3Patch.mpq
mv -f War3Patch.mpq ..
cd ..
rm -R tmp

if [ ! -e "$backupPath" ]; then
	echoStats "Creating backup of \"$path\" to \"$backupPath\"."
	mv "$path" "$backupPath"
fi
ln -fs  "$(pwd)/War3Patch.mpq" "$realPath"
echoSuccess "Finished successfully!"