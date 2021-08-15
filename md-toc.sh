#!/bin/bash

# Output usage message if user does not supply a markdown file
usage() {
	cat <<-EOF
	Usage: $(basename $0) /path/to/markdown.md

	Parsed table of contents from headers in markdown file.
	If markdown contains '[TOC]' the generated table of contents will replace.
	EOF
}

# Parse the markdown file for headers and generate the table of content
toc() {
	grep -e "^#\+ " "$MARKDOWN" | \
		sed -e :1 -e 's/\(^\s*\)#/\1  /; t1' \
		-e 's/   \([^ ].*\)$/* [\1](#\L\1/' \
		-e :2 -e 's/\(#.*\) /\1-/; t2' \
		-e :3 -e 's/\(#.*\)[^a-z0-9_-]/\1/; t3' \
		-e 's/$/)/'
}

# Check if a file was passed to the script
if [ -z "$1" ] || [ ! -f "$1" ]; then
	usage
	exit 1
fi

MARKDOWN="$1"

# First check for headers without additional text, not sure why this is showing up sometimes
sed -i 's/^#\+\s*$//' "$MARKDOWN"

# Unfortunatly I do not know a better method than to write to a temp file
TEMP=$(mktemp)
toc > $TEMP

# Replace line containing [TOC] with table of contents
sed -i -e "/\[TOC\]/ r $TEMP" \
	-e 's/\[TOC\]/# Table of Contents/' "$MARKDOWN"

# Output table of contents so the user knows script is successful
cat $TEMP

# Remove temp file
rm $TEMP
