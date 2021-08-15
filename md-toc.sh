#!/bin/bash

usage() {
	cat <<-EOF
	Usage: $(basename $0) /path/to/markdown.md

	Parsed table of contents from headers in markdown file.
	If markdown contains '[TOC]' the generated table of contents will replace.
	EOF
}

# Generate table of contents and insert in markdown file
toc() {
	local markdown="$1"
	# Unfortunately I do not know a better method than to write to a temp file
	local temp=$(mktemp)

	# First check for headers without additional text, not sure why this is showing up sometimes
	sed -i '/^#\+\s*$/d' "$markdown"

	# Parse all headers and output formatted TOC to temp file
	grep -e "^#\+ " "$markdown" | \
	sed -e :1 -e 's/\(^\s*\)#/\1  /; t1' \
		-e 's/   \([^ ].*\)$/* [\1](#\L\1/' \
		-e :2 -e 's/\(#.*\) /\1-/; t2' \
		-e :3 -e 's/\(#.*\)[^a-z0-9_-]/\1/; t3' \
		-e 's/$/)/' > $temp

	# Replace line containing [TOC] with table of contents
	if [ -s "$temp" ]; then
		sed -i -e "/\[TOC\]/ r $temp" \
		-e 's/\[TOC\]/# Table of Contents/' "$markdown"
		# Output table of contents so the user knows the script is successful
		cat $temp
	else
		echo "ERROR: failed to generate the TOC for '$(basename $markdown)'"
	fi

	# Remove temp file
	rm $temp
}

# Check if any files are supplied otherwise print usage
if [ -z "$1" ]; then
	usage
	exit
fi

for f in "$@"; do
	# Output usage message if file is empty
	if [ ! -s "$f" ]; then
		printf "ERROR: '$(basename $f)' is empty.\n\n"
		usage
		exit 1
	fi
	toc "$f"
done
