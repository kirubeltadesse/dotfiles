#!/bin/bash
folder="$HOME/.dotfiles"

source "$folder/utility/utilities.sh"

# create link 
create_symlink "$folder/nb/nbrc" "$HOME/.nbrc"

# install fzf plugin
nb plugins install "$folder/nb/fzf.nb-plugin"
 
