# This is the install file for the Data Science Platform specifically

# Get the name
os=$(uname)

# write to the `.bashrc` file
filename="$HOME/.bashrc"
text="
# added by the dotfile installer
DOTFILES_DIR=\"$HOME/.dotfiles\"

for DOTFILE in \"\$DOTFILES_DIR\"/system/.{prompt,alias,env,function};
do
        [ -f \"\$DOTFILE\" ] && . \"\$DOTFILE\"
done

alias v=vi
alias aws='aws --endpoint-url https://s3.dev.bcs.bloomberg.com'
set -o vi
"

echo "copy runnable to .bashrc file"
echo -e "$text" >>"$filename"

echo "source ~/.bashrc" >>~/.bash_profile

# append_line $update_config "$filename" "$text"
echo "running git shortcut scripts"
/bin/bash gitConfig/setup.sh "dspEvironment"

# setup the symlink
echo "creating symlink for the vimrc"
ln -s "$HOME/.dotfiles/runcom/.vimrc" "$HOME/.vimrc"


# TODO: add the symlink for the  jupyter notebook keybindings
#
# ln -s "$HOME/.dotfiles/runcom/.jupyter/nbconfig/notebook.json" $HOME/.jupyter/nbconfig/notebook.json
#
# TODO:  add the symlink for the jupyter notebook custom.json
#
# ln -s "$HOME/.dotfiles/runcom/.jupyter/nbconfig/notebook.json" $HOME/.jupyter/nbconfig/notebook.json
#
# TODO: add the symlink for the kaggle config filename
# NOTE: the kaggle.json file is already in the downloads folder
# ln -s "$HOME/.dotfiles/runcom/.kaggle/kaggle.json" $HOME/.config/kaggle/kaggle.json
#
#
