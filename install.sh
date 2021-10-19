# setup the symlink

# we need to backup the current config files

# not that we need to give absolute path to ln

mv ~/dotfiles ~/.dotfiles # making it a dot folder

# creat the symlinks
# ln -sv "~/.dotfiles/runcom/.bash_profile" ~
# ln -sv "~/.dotfiles/runcom/.inputrc" ~
ln -sv "~/.dotfiles/runcom/.vimrc" ~
ln -sv "~/.dotfiles/runcom/.vim" ~
ln -sv "~/.dotfiles/runcom/.tmux.conf" ~
ln -sv "~/.dotfiles/git/.gitconfig" ~
