#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILE_DIR="/tmp/dotfiles"

# Store the user's custom info
EMAIL_FILE="$DOTFILE_DIR/email.txt"
USERNAME_FILE="$DOTFILE_DIR/username.txt"

# Define the function to echo colored text
print() {
	local type="$1"
	local text="$2"

	# Text color codes
	local RED='\033[0;31m'
	local GREEN='\033[0;32m'
	local YELLOW='\033[0;33m'
	local BLUE='\033[0;34m'
	local NC='\033[0m' # No color

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
	update="$1"  # Whether to update (append) the line (1) or not (0)
	line="$2"    # The line of text to be appended
	file="$3"    # The filename of the target file
	pat="${4:-}" # Optional pattern to serach for in the file
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
			echo "$line" >>"$file" # Append the line to the file
			print 'success' "   + Added"
		else
			print 'warning' " 	 ~ Skipped"
		fi
	fi
	#set +e
}

custome_installer() {
	local use_command

	case "$(uname)" in
	Linux)
		use_command="sudo apt-get install -y"
		print 'success' "Environment is (WLS)"
		sudo apt-get update
		$use_command xclip fd-find
		# curl -fSsL https://repo.fig.io/scripts/install-headless.sh | bash
		# enable +clipboard and +xterm_clipboard for vim
		;;
	Darwin)
		print 'success' "Environment is (macOS)"
		use_command="brew install"
		$use_command fd
		$use_command --cask rectangle
		# finish up fzf configuration
		"$(brew --prefix)"/opt/fzf/install

		echo "source ~/.bashrc" >>~/.zshrc
		;;
	*)
		print error "environment is not known: $(uname)"
		ln -s "$HOME/.dotfiles/runcom/.vimrc" "$HOME/"
		exit 1 #returning before running to commands below on dev machines
		;;
	esac
	install_apps "$use_command"
}

package_installed() {
	package="$1"
	command -v "$package" >/dev/null 2>&1
}

# installer function
install_apps() {
	local use_command="$1"
	local packages=("dos2unix" "tmux" "nb" "fzf" "bat" "git-delta") # "vim-gtk" "lynx")
	for package in "${packages[@]}"; do
		if ! package_installed "$package"; then
			print 'progress' "Installling $package ..."
			$use_command "$package"
		else
			print 'warning' "$package is already installed."
		fi
	done
}

# Function to create symbolic links
create_symlink() {
	local source_file=$1
	local target_file=$2

	if [ ! -e "$target_file" ]; then
		ln -s "$source_file" "$target_file"
		echo "Created symlink: $target_file -> $source_file"
	else
		# TODO: ask if the user want to remove the old link
		echo "Skipped: $target_file already exists"
	fi
}

copy_text_2_bashrc() {
	local text=$1
	local file_path="$HOME/.bashrc"

	while IFS= read -r line; do
		append_line 1 "${line}" "${file_path}"
	done <<<"$text"
}

copy_text_2_bashrc() {
	local text=$1
	local file_path="$HOME/.bashrc"

	while IFS= read -r line; do
		append_line 1 "${line}" "${file_path}"
	done <<<"$text"
}

configure_keybase() {
	keybase pgp export | gpg --import                                            # importing public key
	keybase pgp export --secret | gpg --batch --import --allow-secret-key-import # importing private key
}

create_env_file() {
	# TODO ask the use for the git-username
	read -p "Enter git-username: " username
	read -p "Enter git-eamil: " email
	# TODO ask the use for the git-email
	# create a file and write to the file
	true
}

delete_env_file() {
	# this function will be called to delte the env_file 
	# after installation is complete
	true
}
