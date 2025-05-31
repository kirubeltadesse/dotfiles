#!/bin/bash
# Check if the dot directory exist
FOLDER="$HOME/.dotfiles"

if [[ ! -d "$FOLDER" ]]; then
    echo "direcotry does not exist: $FOLDER"
    exit 1
fi

source "$FOLDER/utility/utilities.sh"

initial_setup() {

cat <<-EOF >> ~/.bashrc
# added by the dotfile installer
DOTFILES_DIR="\$HOME/.dotfiles"

for DOTFILE in "\$DOTFILES_DIR"/system/.{env,prompt,alias,function};
do
    [ -f "\$DOTFILE" ] && . "\$DOTFILE"
done

# enable bat for fzf
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--preview="bat --style=numbers --color=always --line-range :500 {}" --bind alt-j:preview-down,alt-k:preview-up,alt-d:preview-page-down,alt-u:preview-page-up'
export FZF_DEFAULT_OPS="--extended"
export FZF_CTRL_T_COMMAND="\$FZF_DEFAULT_COMMAND"

# add clear screen command
bind -x '"\C-g": "clear"'

# source \$HOME/.local/opt/fzf-obc/bin/fzf-obc.bash
export PATH=\$PATH:~/.nb/
export set_PS1
export NB_PREVIEW_COMMAND="bat"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
EOF

    read -r -p "Is this the first setup? (Y/n):" ans
    case "${ans:-Y}" in
        y|Y )
            if [ -d "$FOLDER" ]; then
                print warning "Folder exists"
            else
                echo "Rename folder to .dotfiles"
                mv ~/dotfiles ~/.dotfiles
            fi
            print success "setting up Keybase"
            configure_keybase
            ;;
        n|N )
            print warning "Skipping Keybase setup"
            ;;
        * )
            print error "Command not recongized"
            ;;
    esac
}

setup_git() {
    print "warning" "asking for user information"
    create_env_file
    print "warning" "Running Git shortcut scripts"
    /bin/bash gitConfig/setup.sh
}

setup_os_applications() {
    # Install all the packages
    custome_installer
    install_apps
}

setup_editor_plugins() {
    print "warning" "Downloading vim and tmux package manager..."
    # download vim plug manage
    # Vim (~/.vim/autoload)
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # download TPM - Tmux Plag manager
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

setup_symlinks() {
    # Create symlinks for .vimrc and .ideavimrc
    create_symlink "$HOME/.dotfiles/runcom/vim/.vimrc" "$HOME/.vimrc"
    create_symlink "$HOME/.dotfiles/runcom/config/nvim" "$HOME/.config/nvim"
    create_symlink "$HOME/.dotfiles/gitConfig/gh-dash" "$HOME/.config/gh-dash"
    create_symlink "$HOME/.dotfiles/runcom/vim/.ideavimrc" "$HOME/.ideavimrc"
    create_symlink "$HOME/.dotfiles/runcom/vim" "$HOME/.vim"

    # Creating symlink for .tmux.conf"
    create_symlink "$HOME/.dotfiles/runcom/.tmux.conf" "$HOME/.tmux.conf"
}

setup_pass() {
    . localhistory/setup.sh; link_pass
}

setup_lh() {
    . localhistory/setup.sh; link_lh
}

setup_nb() {
    bash  nb/setup.sh
}

setup_lynx() {
    bash browser/lynx/setup.sh
}

show_help() {
    echo "Usage: setup.sh [all|init|git|lh|nb|os-apps|plugins|link|lynx]"
    echo "Run setup for different parts of your dotfiles."
    echo "all         - Run all setups"
    echo "init        - Run initial setup for bashrc"
    echo "git         - Setup Git configuration"
    echo "lh          - Setup localhistory"
    echo "pass        - Setup pass completion"
    echo "nb          - Setup nb"
    echo "os-apps     - Setup Operating system applications"
    echo "plugins     - Setup plugins for vim editor"
    echo "link        - Setup symlinks for the applications"
    echo "lynx        - Setup lynx browser for the terminal"
}

if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

for arg in "$@"; do
    case $arg in
        all)
            initial_setup
            setup_git
            setup_os_applications
            setup_editor_plugins
            setup_lh
            setup_nb
            setup_symlinks
            setup_lynx
            ;;
        init)
            initial_setup
            ;;
        git)
            setup_git
            ;;
        os-apps)
            setup_os_applications
            ;;
        plugins)
            setup_editor_plugins
            ;;
        pass)
            setup_pass
            ;;
        lh)
            setup_lh
            ;;
        nb)
            setup_nb
            ;;
        link)
            setup_symlinks
            ;;
        lynx)
            setup_lynx
            ;;
        *)
            show_help
            exit 1
            ;;
    esac
done

print success "Setup complete"

