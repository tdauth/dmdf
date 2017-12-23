#!/bin/bash
source dmdf-init

function showCredits()
{
	if [ ! -d "$1" ]; then
		echoError "Directory \"$1\" does not exist."
		return 1
	fi

	if [ ! -e "$1" ]; then
		echoError "File \"$1\" does not exist."
		return 1
	fi

	i=0
	find "$1" -name "Credits.txt" | while read fileName; do cat "$fileName" i=$[$i+1]; done
	echoStats "Found $i files."

	return 0
}

# $1 Directory containing "Credits.txt" files.
# $2 Output file if necessary.
function readCredits()
{
	if [ ! -d "$1" ]; then
		echoError "Directory \"$1\" does not exist."
		return 1
	fi

	if [ ! -e "$1" ]; then
		echoError "File \"$1\" does not exist."
		return 1
	fi

	files=0
	errors=0

	find "$1" -name "Credits.txt" | while read fileName; do
		i=0
		cat "$fileName" | while read line; do
			#echo "Reading line $i"
			#awk [ -F\t ] '{pgm}' | { ddd } [ file="" ]
			# TODO Versagt bei mehr als einem Tabulator.
			column1="$(echo "$line" | awk -F'\t' '{print $1}')"
			column2="$(echo "$line" | awk -F'\t' '{print $2}')"
			column3="$(echo "$line" | awk -F'\t' '{print $3}')"

			#echo "Column 1: $column1 Column 2: $column2 Column 3: $column3"

			if [[ "$column1" = "File" ]] && [[ "$column2" = "Authors" ]] && [[ "$column1" = "Source" ]]; then
				echo "Initial line."
			elif [[ "$column1" = "Name" ]] || [[ "$column2" = "Author" ]] || [[ "$column1" = "From" ]]; then
				errors=$(($errors+1))
				echoError "Deprecated line $i in file \"$fileName\"."
			elif [[ "$column3" = "http://www.wc3campaigns.net/" ]]; then
				errors=$(($errors+1))
				echoError "Deprecated link at line $i in file \"$fileName\"."
			else
				if [ -z "$column1" -a -z "$column2" -a -z "$column3" ]; then
					errors=$(($errors+1))
					echoError "Invalid line (file \"$fileName\", line $i)!" >&2
				else
					files=$(($files+1))
					value="$column1|$column2|$column3"

					if [ -e "$2" ]; then # output file is specified and exists
						echo "$value" >> "$2"
					else
						echo "$value"
					fi
				fi
			fi

			i=$(($i+1))
		done
	done

	echoStats "Found $files files ($errors errors)."

	return 0
}

while getopts "hlr:" flag
do
	if [[ $flag = "h" ]]; then
		echo "Usage:"
		echo "-h Shows this output."
		echo "-l Lists all credits."
		echo "-r <arg> Reads all credits into file <arg>."
		exit 0
	elif [[ $flag = "l" ]]; then
		readCredits "$WC3SDK_PATH/archives"
		readCredits "$DMDF_PATH/archives"
	elif [[ $flag = "r" ]]; then

		if [ ! -e "$OPTARG" ]; then
			echoError "File \"$OPTARG\" does not exist."
			exit 1
		fi

		readCredits "$WC3SDK_PATH/archives" $OPTARG
		readCredits "$DMDF_PATH/archives" $OPTARG
	fi
done