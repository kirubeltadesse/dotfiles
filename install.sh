# we need to backup the current config files

# not that we need to give absolute path to ln

# TODO: simple if/else block
# check if the folder is exist
# check if the dot folder exist 
# mv ~/dotfiles ~/.dotfiles 		# making it a dot folder


sudo apt-get update
sudo apt install dos2unix

# creat the symlinks
# ln -sv "~/.dotfiles/runcom/.bash_profile" ~
# ln -sv "~/.dotfiles/runcom/.inputrc" ~

# write to the `.bashrc` file
filename="$HOME/.bashrc"
text='
# added by the dotfile installer
DOTFILES_DIR="$HOME/.dotfiles"

for DOTFILE in "$DOTFILES_DIR"/system/.{alias,env,function};
do
        [ -f "$DOTFILE" ] && . "$DOTFILE"
done
'

echo "copy runnable to .bashrc file"
echo "$text" >> "$filename"


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

# ln -sv "~/.dotfiles/git/.gitconfig" $HOME/

