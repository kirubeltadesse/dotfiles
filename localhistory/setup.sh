source "$HOME"/.dotfiles/utility/utilities.sh

filebashrc="$HOME/.bashrc"

function link_pass {
    text="
    source $HOME/.dotfiles/localhistory/pass_completion.sh
    complete -o filenames -F _pass pass

    # Custom pass git alias handler
    pass() {
        if [[ \"\$1\" == \"g\" ]]; then
            shift
            git -C ~/.password-store \"\$@\"
        else
            command pass \"\$@\"
        fi
    }

    "

    print warning "Adding bash complete for pass to .bashrc"
while IFS= read -r line; do
append_line 1 "${line}" "${filebashrc}"
done <<<"$text"
}

function link_lh {
    text="
    source $HOME/.dotfiles/localhistory/lh.sh
    source $HOME/.dotfiles/localhistory/lh_completion.sh
    complete -o filenames -F _lh lh
    "

    print warning "Adding bash complete for lh to .bashrc"
while IFS= read -r line; do
append_line 1 "${line}" "${filebashrc}"
done <<<"$text"
}

