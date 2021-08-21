#!/bin/bash
markdown=(${1})
html=(${2})
script_dir="$(dirname $0)"
for ((i=0; i<${#markdown[@]}; i++)); do
	$script_dir/md-toc.sh "${markdown[$i]}"
	$script_dir/fix-images.sh "${markdown[$i]}" "${html[$i]}"
	$script_dir/fix-whitespace.sh "${markdown[$i]}"
done
