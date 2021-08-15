#!/bin/bash

usage() {
	cat <<-EOF
	Usage: $(basename $0) /path/to/markdown.md

	Removes lines with just whitespace and collapses multiple whitespace lines down to one.
	EOF
}

# Cleanup whitespace in markdown file
fix_whitespace() {
	local markdown="$1"
	sed -i 's/^\s*$//' "$markdown"
	sed -i 'N;/^\n$/D;P;D;' "$markdown"
	sed -i '1{/^$/d;}' "$markdown"
}

# Check if any files are supplied otherwise print usage
if [ -z "$1" ]; then
	usage
	exit 1
fi

for f in "$@"; do
	# Output usage message if file is empty
	if [ ! -s "$f" ]; then
		printf "ERROR: '$(basename $f)' is empty.\n\n"
		usage
		exit 1
	fi
	fix_whitespace "$f"
done
