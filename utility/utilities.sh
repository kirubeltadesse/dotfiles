#!/bin/bash

# Define the function to echo colored text
print() {
    local type="$1"
    local text="$2"

    # Text color codes
    local RED='\033[0;31m'
    local GREEN='\033[0;32m'
    local YELLOW='\033[0;33m'
    local BLUE='\033[0;34m'
    local NC='\033[0m'  # No color

    local color=$NC

    case "$type" in
      error)
        color=$RED
        ;;
      warning)
        color=$YELLOW
        ;;
      success)
        color=$GREEN
        ;;
      *)
        color=$NC
        ;;
    esac
    echo -e "${color}${text}${NC}"
}

# Append a line to a file
# Usage: append_line update filname line [pattern]
append_line() {
	# set -e
	local update line file pat lno
	update="$1"										# Whether to update (append) the line (1) or not (0)
	line="$2"										# The line of text to be appended
	file="$3"											# The filename of the target file
	pat="${4:-}"									# Optional pattern to serach for in the file
	lno=""

	print 'success' "Update $file:"
	print '' " - $line"

	# Check if the traget file exists
	if [ -f "$file" ]; then
		# Search for the line or pattern in the file and get line numbers
		if [ $# -lt 4 ]; then
			lno=$(grep -nF "$line" "$file" | sed 's/:.*//' | tr '\n' ' ')
		else
			lno=$(grep -nF "$pat" "$file" | sed 's/:.*//' | tr '\n' ' ')
		fi
	fi

	# If line numbers were found, the line or pattern already esists in the file
	if [ -n "$lno" ]; then
		echo " - Already exists: line #$lno"
	else
		# If update flag is set, append the line to the file
		if [ $update -eq 1 ]; then
			# [ -f "$file" ] && echo >> "$file"			# Add a newline if file exists
			echo "$line" >> "$file"								# Append the line to the file
			print 'success' "   + Added"
		else
			print 'warning' " 	 ~ Skipped"
		fi
	fi
	#set +e
}

# Function to create symbolic links
create_symlink() {
	local source_file="$1"
	local target_file="$2"

	if [ ! -e "$target_file" ]; then
		ln -s "$source_file" "$target_file"
		echo "Created symlink: $target_file -> $source_file"
	else
		echo "Skipped: $target_file already exists"
	fi
}

