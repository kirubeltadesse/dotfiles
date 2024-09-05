#!/bin/bash
# Check if the dot directory exist

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/utility/utilities.sh"
folder="$HOME/.dotfiles"

function initial_setup() {

    text <<- EOF
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
EOF
    # export PROMPT_COMMAND=\"hist; \$PROMPT_COMMAND\"
    # export set_PS1=\"hist; \$set_PS1\"

    read -r -p "Is this every first setup? (Y/n):" ans
    case "$ans" in
        y|Y )
            if [ -d "$folder" ]; then
                print warning "Folder exists"
            else
                echo "Rename folder to .dotfiles"
                mv ~/dotfiles ~/.dotfiles
            fi
            print success "setting up Keybase"
            configure_keybase
            # write to the `.bashrc` file
            copy_text_2_bashrc "$text"
            ;;
        n|N )
            print warning "Keybase is setup"
            ;;
        * )
            print error "Command not recongized"
            ;;
    esac
}

function setup_git() {
    print "warning" "asking for user information"
    create_env_file
    print "warning" "Running Git shortcut scripts"
    /bin/bash gitConfig/setup.sh
}

function setup_os_applications() {
    # Install all the packages
    custome_installer
}

function setup_editor_plugins() {
    print "warning" "Downloading vim and tmux package manager..."

    # TODO: Depricate this plugin manager
    # download vim plug manage
    # Vim (~/.vim/autoload)
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # Neovim (~/.local/share/nvim/site/autoload)
    curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # download TPM - Tmux Plag manager
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

function setup_symlinks() {
    # Create symlinks for .vimrc and .ideavimrc
    create_symlink "$HOME/.dotfiles/runcom/vim/.vimrc" "$HOME/.vimrc"
    create_symlink "$HOME/.dotfiles/runcom/config/nvim" "$HOME/.config/nvim"
    create_symlink "$HOME/.dotfiles/runcom/vim/.ideavimrc" "$HOME/.ideavimrc"
    create_symlink "$HOME/.dotfiles/runcom/vim" "$HOME/.vim"

    # Creating symlink for .tmux.conf"
    create_symlink "$HOME/.dotfiles/runcom/.tmux.conf" "$HOME/.tmux.conf"

    # copy pomodoro script
    create_symlink "$HOME/.tmux/plugins/tmux-pomodoro-plus/scripts/pomodoro.sh" "$HOME/.tmux/plugins/tmux/scripts/pomodoro.sh"
}

function setup_nb() {
    bash  nb/setup.sh
}

function setup_lynx() {
    bash browser/lynx/setup.sh
}

function show_help() {
    echo "Usage: setup.sh [all|git|localhistory|nb|utilities]"
    echo "Run setup for different parts of your dotfiles."
    echo "all         - Run all setups"
    echo "init        - Run initial setup for bashrc"
    echo "git         - Setup Git configuration"
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

