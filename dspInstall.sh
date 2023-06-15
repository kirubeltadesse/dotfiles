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
"

echo "copy runnable to .bashrc file"
echo -e "$text" >> "$filename"

# append_line $update_config "$filename" "$text" 
echo "running git shortcut scripts"
/bin/bash gitConfig/gitScript.sh "dspEvironment" 

# setup the symlink
echo "creating symlink for the vimrc"
ln -s "$HOME/.dotfiles/runcom/.vimrc" $HOME/


