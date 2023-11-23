#!/bin/bash
# Check if the dot directory exist
folder="$HOME/.dotfiles"

source $folder/utility/utilities.sh

if [ -d "$folder" ]; then
	echo "Folder exists"
else
	echo "Rename folder to .dotfiles"
	mv ~/dotfiles ~/.dotfiles
fi

# write to the `.bashrc` file
filename="$HOME/.bashrc"
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

while IFS= read -r line; do
	append_line 1 "${line}" "${filename}"
done <<< "$text"

print warning "Running Git shortcut scripts"
/bin/bash gitConfig/gitScript.sh

# Get the name
os=$(uname)
# add this git configuration for MacOs, windows and SunOS
if [ "$os" == "Linux" ]; then
	print warning "Environment is $os (WLS)"
	sudo apt-get update
	sudo apt-get install -y xclip vim-gtk dos2unix tmux nb fd-find bat
	# curl -fSsL https://repo.fig.io/scripts/install-headless.sh | bash
	# enable +clipboard and +xterm_clipboard for vim
elif [ "$os" == "Darwin" ]; then
	print warning "Environment is $os (macOS)"
	brew update
	brew install dos2unix tmux fd fzf bat nb
	brew install --cask rectangle
	brew install lynx
	# finish up fzf configuration
	$(brew --prefix)/opt/fzf/install
	echo "source ~/.bashrc" >> ~/.zshrc
else
	print error "environment is not known: $os"
	ln -s "$HOME/.dotfiles/runcom/.vimrc" $HOME/
	exit 0 # returning before running to commands below on dev machines

fi
print warning "Downloading vim and tmux package manager..."
# download vim plug manage
# Vim (~/.vim/autoload)
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Neovim (~/.local/share/nvim/site/autoload)
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# download TPM - Tmux Plag manager
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Create symlinks for .vimrc and .ideavimrc
create_symlink "$HOME/.dotfiles/runcom/vim/.vimrc" "$HOME/.vimrc"
create_symlink "$HOME/.dotfiles/runcom/vim/.ideavimrc" "$HOME/.ideavimrc"
create_symlink "$HOME/.dotfiles/runcom/vim" "$HOME/.vim"

# Creating symlink for .tmux.conf"
create_symlink "$HOME/.dotfiles/runcom/.tmux.conf" "$HOME/.tmux.conf"

# copy pomodoro script
create_symlink "$HOME/.tmux/plugins/tmux-pomodoro-plus/scripts/pomodoro.sh" "$HOME/.tmux/plugins/tmux/scripts/pomodoro.sh"

