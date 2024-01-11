#!/bin/bash

################################################## Lynx #######################################

# Lynx requires the -cfg to look for configuration in someplace other than 
# its own master lynx.cfg file. This requires reloading the shell if these
# files move for any reason. (They are symlinks in this config.) The best 
# way to get around this configuration issue and still allow lynx to be 
# called from other programs is to encapsulate it with a function.
folder="$HOME/.dotfiles/browser/lynx"
source "$HOME/.dotfiles/utility/utilities.sh"

filebashrc="$HOME/.bashrc"
text="

############ from lynx setupe ################
lynxpath=$(which lynx)


if [ -e \"\$HOME/.config/lynx/lynx.cfg\" ];then
  export LYNX_CFG=\"\$HOME/.config/lynx/lynx.cfg\"
fi

if [ -e \"\$HOME/.config/lynx/lynx.lss\" ];then
  export LYNX_LSS=\"\$HOME/.config/lynx/lynx.lss\"
fi

if [ ! -x \"\$lynxpath\" ]; then
  echo \"Doesn't look like lynx is installed.\"
  exit 1
fi

source \"$folder/urlencode\"
source \"$folder/searchEngine\"
"
echo "$text" >> "$filebashrc"

# Specify the directory to add to the PATH
lynxpath="$(which lynx)"

# Check if the directory is not already in the PATH
if [[ ":$PATH:" != *":lynxpath:"* ]]; then
    # Append the directory to the PATH and update the shell configuration file
    echo "export PATH=\$PATH:$lynxpath" >> ~/.bashrc
    # Source the updated configuration file to apply changes in the current session
    source ~/.bashrc
    echo "Directory added to PATH: $lynxpath"
else
    echo "Directory is already in PATH: $lynxpath"
fi

mk "$HOME/.config/lynx"

create_symlink "$folder/lynx.cfg" "$HOME/.config/lynx/lynx.cfg"
create_symlink "$folder/lynx.lss" "$HOME/.config/lynx/lynx.lss"

