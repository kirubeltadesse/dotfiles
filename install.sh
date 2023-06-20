#!/bin/bash

# Check if the dot directory exist
folder="$HOME/.dotfiles"

if [ -d "$folder" ]; then
	echo "Folder exists"
else
	echo "Rename folder to .dotfiles"
	mv ~/dotfiles ~/.dotfiles
fi

# Append a line to a file
# Usage: append_line update filname line [pattern]
append_line() {
	# set -e
	local update line file pat lno
	update="$1"
	line= "$2"
	file="$3"
	pat="${4:-}"
	lno=""
	
	echo "Update $file:"
	echo " - $line"
	if [ -f "$file" ]; then
		if [ $# -lt 4 ]; then
			lno=$(\grep -nF "$line" "$file" | sed 's/:.*//' | tr '\n' ' ')
		else
			lno=$(\grep -nF "$pat" "$file" | sed 's/:.*//' | tr '\n' ' ')
		fi
	fi
	if [ -n "$lno" ]; then
		echo " - Already exists: line #$lno"
	else
		if [ $update -eq 1 ]; then
			[ -f "$file" ] && echo >> "$file"
			echo "$line" >> "$file"
			echo "   + Added"
		else
			echo " 	 ~ Skipped"
		fi
	fi
	#set +e
}

# write to the `.bashrc` file
filename="$HOME/.bashrc"
text="
# added by the dotfile installer
DOTFILES_DIR=\"\$HOME/.dotfiles\"

for DOTFILE in \"\$DOTFILES_DIR\"/system/.{env,prompt,alias,function};
do 
        [ -f \"\$DOTFILE\" ] && . \"\$DOTFILE\"
done

# enable bat for fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--preview \"bat --style=numbers --color=always --line-range :500 {}\"'
export FZF_DEFAULT_OPS=\"--extended\"
export FZF_CTRL_T_COMMAND=\"\$FZF_DEFAULT_COMMAND\"

# add clear screen command
bind -x '\"\C-g\": \"clear\"'

# source \$HOME/.local/opt/fzf-obc/bin/fzf-obc.bash
export PATH=\$PATH:~/.nb/

export NB_PREVIEW_COMMAND=\"bat\"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

"
# append_line 1 "$text" "$filename"

# Check if each line in `text` exists in ~/.bashrc
while IFS= read -r line; do
    if grep -qF "$line" ~/.bashrc; then
        echo "Updating line in ~/.bashrc:"
        echo "$line"
        sed -i "s|.*$line.*|$line|" ~/.bashrc
    else
        echo "Appending line to ~/.bashrc:"
        echo "$line"
        echo "$line" >> ~/.bashrc
    fi
done <<< "$text"

echo "running git shortcut scripts"
/bin/bash gitConfig/gitScript.sh

# Get the name 
os=$(uname)
# add this git configuration for MacOs, windows and SunOS
if [ "$os" == "Linux" ]; then
	echo "Environment is $os (WLS)"
	sudo apt-get update
	sudo apt-get install -y xclip vim-gtk dos2unix fd-find bat 
	# curl -fSsL https://repo.fig.io/scripts/install-headless.sh | bash
	# enable +clipboard and +xterm_clipboard for vim
elif [ "$os" == "Darwin" ]; then
	echo "Environment is $os (macOS)"
	brew update 
	brew install dos2unix fd bat 
#	brew install fig 
#	brew install git bash-completion
	echo "source ~/.bashrc" >> ~/.zshrc
else
	echo "environment is not known: $os"
	ln -s "$HOME/.dotfiles/runcom/.vimrc" $HOME/
	exit 0 # returning before running to commands below on dev machines
fi

echo "Downloading vim and tmux package manager..."
# download vim plug manage
# Vim (~/.vim/autoload)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Neovim (~/.local/share/nvim/site/autoload)
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# download TPM - Tmux Plag manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Function to create symbolic links
create_symlink() {
	local source_file="$1"
	local target_file="$2"
	
	if [ ! e "$target_file" ]; then
		ln -s "$source_file" "$target_file"
		echo "Created symlink: $target_file -> $source_file"
	else
		echo "Skipped: $target_file already exists"
	fi
}


# Create symlinks for .vimrc and .ideavimrc
create_symlink "$HOME/.dotfiles/runcom/vim/.vimrc" "$HOME/.vimrc"
create_symlink "$HOME/.dotfiles/runcom/vim/.ideavimrc" "$HOME/.ideavimrc"
create_symlink "$HOME/.dotfiles/runcom/vim" "$HOME/.vim" 

# TODO: install vim-airline using Pathogen
# https://codybonney.com/install-vim-airline-using-pathogen/ 

# Creating symlink for .tmux.conf"
create_symlink "$HOME/.dotfiles/runcom/.tmux.conf" "$HOME/.tmux.conf"

