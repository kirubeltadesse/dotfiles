# This is the install file for the Data Science Platform specifically

# Get the name 
os=$(uname)
# add this git configuration for MacOs, windows and SunOS
if [ "$os" == "Linux" ]; then
	echo "environment is $os wls"
elif [ "$os" == "Darwin" ]; then
	echo "environment is $os mac"
	brew update 
	brew install dos2unix 
	brew install fd 
#	brew install fig 
	brew install git bash-completion
	brew install bat 
	echo "source ~/.bashrc" >> ~/.zshrc
else
	echo "environment is not known: $os"
fi

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
"

echo "copy runnable to .bashrc file"
echo -e "$text" >> "$filename"

# append_line $update_config "$filename" "$text" 
echo "running git shortcut scripts"
/bin/bash gitConfig/gitScript.sh


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


