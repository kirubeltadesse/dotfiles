#!/bin/bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILE_TEMP_DIR="/tmp/dotfiles"

# Store the user's custom info
INSTALLER_COMMAND="$DOTFILE_TEMP_DIR/command.txt"
EMAIL_FILE="$DOTFILE_TEMP_DIR/email.txt"
USERNAME_FILE="$DOTFILE_TEMP_DIR/username.txt"

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
	pat="${4:-}" # Optional pattern to search for in the file
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

	# If line numbers were found, the line or pattern already exists in the file
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
    create_env_file

	case "$(uname)" in
	Linux)
		use_command="apt-get install -y"
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
		$use_command --cask font-jetbrains-mono-nerd-font
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
    write_to_file "$use_command" "$INSTALLER_COMMAND"
}

package_installed() {
	package="$1"
	command -v "$package" >/dev/null 2>&1
}

# installer function
install_apps() {
    local use_command
    use_command="$(read_file "$INSTALLER_COMMAND")"
	local packages=("dos2unix" "tmux" "nb" "fzf" "bat" "luarocks" "git-delta" "neovim" "jq" "shunit2") # "vim-gtk" "lynx")
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
	local source_file="$1"
	local target_file="$2"
    local target_dir

    # Get the directory of the target file
    target_dir=$(dirname "$target_file")

    # Check if the target directory exists, if not create it
    if [ ! -d "$target_dir" ]; then
        print error "Directory $target_dir does not exist. Createing it ..."
        mkdir -p "$target_dir"
    fi

	if [ ! -e "$target_file" ]; then
		ln -s "$source_file" "$target_file"
		echo "Created symlink: $target_file -> $source_file"
	else
		# TODO: ask if the user want to remove the old link
		echo "Skipped: $target_file already exists"
	fi
}

copy_text_2_bashrc() {
    # TODO: Not sure if I need this anymore
	local text="$1"
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
    if check_file "$USERNAME_FILE"; then
        clean_env
    	mkdir -p $DOTFILE_TEMP_DIR
    	read -r -p "Enter git-username: " username
    	read -r -p "Enter git-eamil: " email
    	write_to_file "$username" "$USERNAME_FILE"
    	write_to_file "$email" "$EMAIL_FILE"
    else
        print 'warning' "Using the previsious setting"
    fi
}

check_file() {
    local file_path="$1"

    if [ -f "$file_path" ]; then
        read -r -p "File '$file_path' exists. Do you want to overwrite it? (y/n): " choice
        case "$choice" in
            y|Y )
                echo "Overwriting file '$file_path'..."
                # Perform the action to overwrite the file
                ;;
            n|N )
                echo "Skipping overwrite for file '$file_path'."
                return 1  # Skip further actions for this file
                ;;
            * )
                echo "Invalid choice. Please enter y or n."
                check_file "$file_path"  # Re-prompt the user
                ;;
        esac
    else
        echo "File '$file_path' does not exist. Continuing..."
    fi
}


write_to_file() {
	local data="$1"
	local file="$2"
	echo "$data" >"$file"
}

read_file() {
	local file="$1"
	local lines=()
	if [ -f "$file" ]; then
		while IFS= read -r line; do
			lines+=("$line") # Store each line in an array
		done <"$file"
		echo "${lines[@]}" # Output the array content
	else
		echo 1
	fi
}

clean_env() {
	remove_file "$USERNAME_FILE"
	remove_file "$EMAIL_FILE"
	remove_file "$INSTALLER_COMMAND"
	rm -f $DOTFILE_TEMP_DIR
}

remove_file() {
	local file="$1"
	if [ -f "$file" ]; then
		rm "$file"
	fi
}

