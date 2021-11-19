# setup the symlink

# we need to backup the current config files

# not that we need to give absolute path to ln

# TODO: simple if/else block
# check if the folder is exist
# check if the dot folder exist 
# mv ~/dotfiles ~/.dotfiles 																					# making it a dot folder

# creat the symlinks
# ln -sv "~/.dotfiles/runcom/.bash_profile" ~
# ln -sv "~/.dotfiles/runcom/.inputrc" ~
ln -sv "~/.dotfiles/runcom/.vim/.vimrc" $HOME/
ln -sv "~/.dotfiles/runcom/.vim" $HOME/
ln -sv "~/.dotfiles/runcom/.tmux.conf" $HOME/
# ln -sv "~/.dotfiles/git/.gitconfig" $HOME/
