# not that we need to give absolute path to ln

# TODO: simple if/else block
# check if the folder is exist
# check if the dot folder exist 
# mv ~/dotfiles ~/.dotfiles 		# making it a dot folder

# run this in any of the machine


# Get the name 
os=$(uname)
# add this git configuration for MacOs, windows and SunOS
if [ "$os" == "Linux" ]; then
	echo "environment is $os wls"
	sudo apt-get update
	sudo apt install dos2unix fd-find bat 
	# curl -fSsL https://repo.fig.io/scripts/install-headless.sh | bash
elif [ "$os" == "Darwin" ]; then
	echo "environment is $os mac"
	brew update 
	brew install dos2unix 
	brew install fd 
#	brew install fig 
	brew install bat 
	echo "source ~/.bashrc" >> ~/.zshrc
else
	echo "environment is not known: $os"
fi

append_line() {
	set -e
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
			[-f "$file" ] && echo >> "$file"
			echo "$line" >> "$file"
			echo "   + Added"
		else
			echo " 	 ~ Skipped"
		fi
	fi
	echo 
	set +e
}

# creat the symlinks
# ln -sv "~/.dotfiles/runcom/.bash_profile" ~
# ln -sv "~/.dotfiles/runcom/.inputrc" ~

# write to the `.bashrc` file
filename="$HOME/.bashrc"
text="
# added by the dotfile installer
DOTFILES_DIR=\"$HOME/.dotfiles\"

for DOTFILE in \"\$DOTFILES_DIR\"/system/.{alias,env,function};
do
        [ -f \"\$DOTFILE\" ] && . \"\$DOTFILE\"
done

# enable bat for fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--preview \"bat --style=numbers --color=always --line-range :500 {}\"'
export FZF_DEFAULT_OPS=\"--extended\"
export FZF_CTRL_T_COMMAND=\"\$FZF_DEFAULT_COMMAND\"
"

echo "copy runnable to .bashrc file"
echo -e "$text" >> "$filename"


# append_line $update_config "$filename" "$text" 

echo "running git shortcut scripts"
/bin/bash gitConfig/gitScript.sh


echo "Downloading vim and tmux package manager..."
# download vim plug manage
# Vim (~/.vim/autoload)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Neovim (~/.local/share/nvim/site/autoload)
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

#curl -fLo ~/.vim/autoload/install.sh \
#	 https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh \
#	 /bin/bash ~/.vim/autoload/install.sh 

# download TPM - Tmux Plag manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# setup the symlink
echo "creating symlink for the vimrc"
ln -s "$HOME/.dotfiles/runcom/vim/.vimrc" $HOME/
ln -s "$HOME/.dotfiles/runcom/vim/.ideavimrc" $HOME/
# ln -F "$HOME/.dotfiles/runcom/vim" $HOME/.vim # make this a hard link
ln -s "$HOME/.dotfiles/runcom/vim" $HOME/.vim 

# TODO: install vim-airline using Pathogen
# https://codybonney.com/install-vim-airline-using-pathogen/ 

echo "creating symlink for the tmux.conf"
ln -s "$HOME/.dotfiles/runcom/.tmux.conf" $HOME/

# ln -sv "~/.dotfiles/git/.gitconfig" $HOME/

