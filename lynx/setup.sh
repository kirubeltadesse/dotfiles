#!/bin/bash

################################################## Lynx #######################################

# Lynx requires the -cfg to look for configuration in someplace other than 
# its own master lynx.cfg file. This requires reloading the shell if these
# files move for any reason. (They are symlinks in this config.) The best 
# way to get around this configuration issue and still allow lynx to be 
# called from other programs is to encapsulate it with a function.
folder="$HOME/.dotfiles"
source "$folder/utility/utilities.sh"

filebashrc="$HOME/.bashrc"
text="

############ from lynx setupe ################
lynxpath=\$(which lynx)

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

source \"\$HOME/.dotfiles/lynx/urlencode\"
source \"\$HOME/.dotfiles/lynx/searchEngine\"
"
echo "$text" >> "$filebashrc"


create_symlink "$folder/lynx/lynx.cfg" "$HOME/.config/lynx/lynx.cfg"
create_symlink "$folder/lynx/lynx.lss" "$HOME/.config/lynx/lynx.lss"

