#!/usr/local/bin/bash

# TODO: taking idea from https://github.com/sanekits/localhist/blob/main/bin/localhist-cleanup.sh
# [[ -z $SNPPETS ]] && echo "SNIPPETS	 directory undefined" && exit 1

# echo "$SNIPPETS"
# complete -F kirubel kirubel

declare -a COMMANDS=(foo bar blah)

if [[ -n $COMP_LINE ]]; then
	for c in "${COMMANDS[@]}"; do
		[[ ${c:0:${#2}} == ${2,,} ]] && echo "$c" 	
	done
	exit
fi

_lh() {
# This is the entry point
echo "test"
}


_foo() {
	echo would foo
}

_bar() {
	echo would bar
}

_blah() {
	echo would blah with "$1" 
}

declare cmd="$1"; shift

for c in  "${COMMANDS[@]}"; do 
	[[ "$c" == $cmd ]] &&  "_$cmd" "$@" && exit $?

done

