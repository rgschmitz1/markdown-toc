#!/bin/bash

if [ -z "$1" ] || [ ! -f "$1" ]; then
	cat <<-EOF
	Usage: $(basename $0) /path/to/markdown.md

	Removes lines with just whitespace and collapses multiple whitespace lines down to one.
	EOF
	exit 1
fi

MARKDOWN="$1"
sed -i 's/^\s*$//; $!N;/^\n$/{$q;D;};P;D;' $MARKDOWN
sed -i '1{/^$/d;}; ${/^$/d;}' $MARKDOWN
