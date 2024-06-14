#!/bin/bash
# Check if the dot directory exist

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


folder="$HOME/.dotfiles"
source "$CURRENT_DIR/utility/utilities.sh"

text="
# added by the dotfile installer
DOTFILES_DIR=\"\$HOME/.dotfiles\"

for DOTFILE in \"\$DOTFILES_DIR\"/system/.{env,prompt,alias,function};
do
	[ -f \"\$DOTFILE\" ] && . \"\$DOTFILE\"
done

# enable bat for fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--preview=\"bat --style=numbers --color=always --line-range :500 {}\" --bind alt-j:preview-down,alt-k:preview-up,alt-d:preview-page-down,alt-u:preview-page-up'
export FZF_DEFAULT_OPS=\"--extended\"
export FZF_CTRL_T_COMMAND=\"\$FZF_DEFAULT_COMMAND\"

# add clear screen command
bind -x '\"\C-g\": \"clear\"'

# source \$HOME/.local/opt/fzf-obc/bin/fzf-obc.bash
export PATH=\$PATH:~/.nb/
export set_PS1
export NB_PREVIEW_COMMAND=\"bat\"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
"
# export PROMPT_COMMAND=\"hist; \$PROMPT_COMMAND\"
# export set_PS1=\"hist; \$set_PS1\"

read -p "Is this every first setup? (Y/n):" ans

if [ $ans == 'Y' ]; then
	if [ -d "$folder" ]; then
		print warning "Folder exists"
	else
		echo "Rename folder to .dotfiles"
		mv ~/dotfiles ~/.dotfiles
	fi
	print success "setting up Keybase"
	configure_keybase

	print "warning" "asking for user information"
	create_env_file

	# write to the `.bashrc` file
	copy_text_2_bashrc "$text"
else
	print warning "Keybase is setup"
fi

print "warning" "Running Git shortcut scripts"
/bin/bash gitConfig/setup.sh

# Install all the packages
custome_installer
print "warning" "Downloading vim and tmux package manager..."

# download vim plug manage
# Vim (~/.vim/autoload)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Installing nvim
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# Neovim (~/.local/share/nvim/site/autoload)
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# download TPM - Tmux Plag manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm


# Create symlinks for .vimrc and .ideavimrc
create_symlink "$HOME/.dotfiles/runcom/vim/.vimrc" "$HOME/.vimrc"
create_symlink "$HOME/.dotfiles/runcom/config/nvim" "$HOME/.config/nvim"
create_symlink "$HOME/.dotfiles/runcom/vim/.ideavimrc" "$HOME/.ideavimrc"
create_symlink "$HOME/.dotfiles/runcom/vim" "$HOME/.vim"

# Creating symlink for .tmux.conf"
create_symlink "$HOME/.dotfiles/runcom/.tmux.conf" "$HOME/.tmux.conf"

# copy pomodoro script
create_symlink "$HOME/.tmux/plugins/tmux-pomodoro-plus/scripts/pomodoro.sh" "$HOME/.tmux/plugins/tmux/scripts/pomodoro.sh"
