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
      progress)
        color=$BLUE
        ;;
      success)
        color=$GREEN
        ;;
      *)
        color=$NC
        ;;
    esac
    echo -e "${color}${text}${NC}" >&2
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
		if [ "$update" -eq 1 ]; then

			# [ -f "$file" ] && echo >> "$file"			# Add a newline if file exists
			echo "$line" >> "$file"								# Append the line to the file
			print 'success' "   + Added"
		else
			print 'warning' " 	 ~ Skipped"
		fi
	fi
	#set +e
}

get_user_command() {
	local use_command;
	os=$(uname)

	if [ "$os" == "Linux" ]; then
		print 'success' "Environment is $os (WLS)"
		use_command="sudo apt-get install -y"
		sudo apt-get update
		$use_command xclip fd-find
		# curl -fSsL https://repo.fig.io/scripts/install-headless.sh | bash
		# enable +clipboard and +xterm_clipboard for vim
	elif [ "$os" == "Darwin" ]; then
		print 'success' "Environment is $os (macOS)"
		use_command="brew install"
		$use_command update
		$use_command fd
		$use_command --cask rectangle
		# finish up fzf configuration
		"$(brew --prefix)"/opt/fzf/install
		echo "source ~/.bashrc" >> ~/.zshrc
	else
		print error "environment is not known: $os"
		ln -s "$HOME/.dotfiles/runcom/.vimrc" "$HOME/"
		exit 1  #returning before running to commands below on dev machines
	fi

	echo "$use_command"
}

package_installed() {
	package="$1"
	command -v "$package" >/dev/null 2>&1
}

# installer function
custome_installer() {

	local use_command
	use_command=$(get_user_command)
	packages=("dos2unix" "tmux" "glow" "nb" "fzf" "bat" "pass" "keybase" "gpg") #  "vim-gtk" "lynx"

	for package in "${packages[@]}"; do
		if ! package_installed "$package" ; then
			print 'progress' "Installling $package ..."
			"$use_command" "$package"
		else
			print 'warning' "$package is already installed."
		fi
	done
}


# Function to create symbolic links
create_symlink() {
	local source_file="$1"
	local target_file="$2"

	if [ ! -e "$target_file" ]; then
		ln -s "$source_file" "$target_file"
		echo "Created symlink: $target_file -> $source_file"
	else
		# TODO: ask if the user want to remove the old link	
		echo "Skipped: $target_file already exists"
	fi
}

copy_text_2_bashrc() {
	local text="$1"
	local file_path="$HOME/.bashrc"

	while IFS= read -r line; do
		append_line 1 "${line}" "${file_path}"
	done <<< "$text"
}

configure_keybase() {
# TODO: import keys from keybase
 	keybase pgp export | gpg --import # importing public key
	keybase pgp export --secret | gpg --batch --import --allow-secret-key-import # importing private key
}


