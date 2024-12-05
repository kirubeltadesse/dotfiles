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
    COMPREPLY=($(compgen -W "init add remove info set unset swap" "${COMP_WORDS[1]}"))
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

get_command() {

    if [ "${#COMP_WORDS[@]}" != "2" ]; then
        return
    fi

    # check if env variable is set or use the default
    local com_nums=${LH_COMMANDS_NUMBER:-50}
    local IFS=$'\n'
    local suggestions=($(compgen -W "$(fc -l -"$com_nums" | sed 's/\t//')" -- "${COMP_WORDS[1]}"))

    if [ "${#suggestions[@]}" == "1" ]; then
        # if there's only one match, we remove the command literal
        # to proceed with the automatic complete of the number
        local number=$(echo "${suggestions[0]/%\*/}")
        COMPREPLY=("$number")
    else
        for i in "${!suggestions[@]}";
        do
            suggestions[$i]="$(printf '%*s' "-$COLUMNS" "${suggestions[$i]}")"
        done

        # more than one suggestions resolved
        # respond with the suggestions intact
        COMPREPLY=("${suggestions[@]}")
        fi
}

declare cmd="$1"; shift

for c in  "${COMMANDS[@]}"; do 
    [[ "$c" == "$cmd" ]] &&  "_$cmd" "$@" && exit $?
done

