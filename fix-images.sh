#!/bin/bash

usage() {
	cat <<-EOF
	Usage: $(basename $0) /path/to/markdown.md /path/to/googleDocs.html

	Input markdown.md followed by the Google generated html file to patch
	up image names.
	EOF
}

if [[ -z "$1" || -z "$2" || ! -f "$1" || ! -f "$2" ]]; then
	usage
	exit 1
fi

MARKDOWN="$1"
HTML="$2"

# Delete all gd2md inline alerts (additional optional headers have been removed in advance)
sed -i '/gdcalert/d; /gd2md-html alert/d; /<p .*delete this message.*p>/d' "$MARKDOWN"

# Gather source and destination file names
srcimages=($(grep -o 'images/image[0-9]\+\.\w\+' "$HTML"))
destimages=($(awk '/images\/image[0-9]+\.\w+/ {print NR}' "$MARKDOWN"))
# Verify source and destination counts match up
if [ ${#srcimages[*]} -ne ${#destimages[*]} ]; then
	echo "ERROR: html and markdown image counts differ, please verify files are correct"
	exit 1
fi
for((i=0; i<${#srcimages[*]}; i++)); do
	sed -i "${destimages[$i]}s|^!.*(images/image[0-9]\+\.\w\+.*)|![](${srcimages[$i]})|" "$MARKDOWN"
done
