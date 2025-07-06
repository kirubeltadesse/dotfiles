#!/bin/bash

source "$HOME/.dotfiles/utility/utilities.sh"

function get_completion() {
    print warning "Installing git completion"

    # Check if the download was successful
    if curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash; then
        print warning "Downlaod successful."

        # Make the downloaded file executable
        print warning "Making it executable"
        if chmod +x ~/.git-completion.bash; then
            print "warning" "File is now executable."
        else
            print "error" "Error: Failed to make the file executable."
        fi
    else
        print "error" "Error: Download failed."
    fi
}

function add_to_rc_file() {
    print warning "Adding referance line to .bash_profile"
    # Adding the referace to the bash completion to the .bash_profile
    filebashprofile="$HOME/.bash_profile"
    text_forprofile="
    if [ -f ~/.git-completion.bash ]; then
        . ~/.git-completion.bash
    fi
    "

    while IFS= read -r line; do
        append_line 1 "${line}" "${filebashprofile}"
    done <<<"$text_forprofile"

    filebashrc="$HOME/.bashrc"
    text="complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g 2>/dev/null \
        complete -o default -o nospace -F __git_wrap__git_main g"

    print warning "Adding bash complete for git alias line to .bashrc"
    while IFS= read -r line; do
        append_line 1 "${line}" "${filebashrc}"
    done <<<"$text"
}

function add_git_aliases() {
    # creating alias for git
    print warning "setup up git shortcuts"

    # this is more formal way to create the git alias
    # https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases
    git config --global init.defaultBranch main
    git config --global credential.helper cache
    git config --global core.editor nvim

    if [[ "$USER" != "kirubeltadesse" ]]; then
        git config --global http.https://github.com.proxy http://proxy.bloomberg.com:81
        git config --global http.https://gitlab.com.proxy http://proxy.bloomberg.com:81
        git config --global http.https://github.com.sslCAinfo ~/bb-cert/bloomberg-root-ca.crt
        git config --global credential.https://github.com.name "$(read_file "$USERNAME_FILE")"
        git config --global credential.https://github.com.email "$(read_file "$EMAIL_FILE")"
    fi
    git config --global branch.autosetuprebase always

    append_line 1 "#----------------------------------- general -----------------------------------" ~/.gitconfig

    git config --global alias.a add
    git config --global alias.co checkout
    git config --global alias.b branch

    # For `bdone` alias - Delete all fully merged branches except the current one
    git config --global alias.bdone "!git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d"

    # Define `bclean` alias
    # This version first detects the default branch (`main` or `master`) from the remote, then switches to it
    # and deletes all branches that have been merged.
    git config --global alias.bclean "!git checkout \$(git remote show origin | grep 'HEAD branch' | awk '{print \$NF}') && git branch --merged | grep -v '\\*' | xargs -n 1 git branch -d"

    git config --global alias.rclean "!git branch -r --merged origin/$(git remote show origin | grep 'HEAD branch' | awk '{print \$NF}') | grep -v 'origin/HEAD' | grep -v 'origin/$(git remote show origin | grep 'HEAD branch' | awk '{print \$NF}')' | sed 's/origin\\///' | xargs -n 1 git push origin --delete"

    git config --global alias.c commit
    git config --global alias.cp cherry-pick
    git config --global alias.cpa 'cherry-pick --abort'
    git config --global alias.cpc 'cherry-pick --continue'
    git config --global alias.d diff
    git config --global alias.dsw 'diff --staged --word-diff=color --color-moved'
    git config --global alias.dw 'diff --word-diff=color --color-moved'
    git config --global alias.f fetch

    append_line 1 "#----------------------------------- log -----------------------------------" ~/.gitconfig

    git config --global alias.loga 'log --author'
    git config --global alias.logoa 'log --oneline --author'
    git config --global alias.logboa 'log --branches --oneline --author'
    git config --global alias.logbna 'log --branches --no-walk --author'
    git config --global alias.logdog 'log --decorate --oneline --graph'
    git config --global alias.logg 'log --patch -G'
    git config --global alias.logs 'log --stat'
    git config --global alias.m merge
    git config --global alias.ps push
    git config --global alias.pl pull

    append_line 1 "#----------------------------------- remote -----------------------------------" ~/.gitconfig

    git config --global alias.r remote
    git config --global alias.ra 'remote add'
    git config --global alias.rr 'remote rm'
    git config --global alias.rv 'remote -v'
    git config --global alias.rn 'remote rename'
    git config --global alias.rs 'remote show'

    append_line 1 "#----------------------------------- rebase -----------------------------------" ~/.gitconfig

    git config --global alias.rb rebase
    git config --global alias.rba 'rebase --abort'
    git config --global alias.rbc 'rebase --continue'
    git config --global alias.rbi 'rebase --interactive'
    git config --global alias.rbs 'rebase --skip'

    append_line 1 "#----------------------------------- reset -----------------------------------" ~/.gitconfig

    git config --global alias.re 'reset'
    git config --global alias.rh 'reset HEAD'
    git config --global alias.reh 'reset --hard'
    git config --global alias.rem 'reset --mixed'
    git config --global alias.res 'reset --soft'
    git config --global alias.rehh 'reset --hard HEAD'
    git config --global alias.remh 'reset --mixed HEAD'
    git config --global alias.resh 'reset --soft HEAD'
    git config --global alias.rehom "reset --hard origin/$(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@')"

    append_line 1 "#----------------------------------- restore -----------------------------------" ~/.gitconfig

    git config --global alias.rs restore
    git config --global alias.rss 'restore --staged'

    append_line 1 "#----------------------------------- show -----------------------------------" ~/.gitconfig

    git config --global alias.w 'show'
    git config --global alias.wno 'show --name-only'

    append_line 1 "#----------------------------------- stash -----------------------------------" ~/.gitconfig

    git config --global alias.sa 'stash apply'
    git config --global alias.sc 'stash clear'
    git config --global alias.sd 'stash drop'
    git config --global alias.sl 'stash list'
    git config --global alias.sp 'stash pop'
    git config --global alias.sps 'stash push'
    git config --global alias.ss 'stash save'
    git config --global alias.st status
    git config --global alias.sw 'stash show'
    git config --global alias.swp 'stash show -p'

    # add this git configuration for MacOs, windows and SunOS
    case "$(uname)" in
    Darwin | Linux | SunOS)
        # if [ $# -eq 0 ]; then
        # setting vim for git tool
        git config --global diff.tool vimdiff
        git config --global merge.tool vimdiff
        git config --global merge.conflictstyle diff3
        git config --global mergetool.prompt false
        git config --global core.excludesFile "${HOME}/.dotfiles/gitConfig/gitignore"
        # add delta configuration
        git config --global core.pager delta
        git config --global interactive.diffFilter "delta --color-only --features=interactive"
        git config --global delta.features decorations
        git config --global delta.line-numbers true
        git config --global delta.interactive.keep-plus-minus-markers false
        git config --global delta.decorations.commit-decoration-style "blue ol"
        git config --global delta.decorations.hunk-header-decoration-style "blue box"
        git config --global delta.decorations.hunk-header-file-style red
        git config --global delta.decorations.hunk-header-style "file line-number syntax"
        git config --global delta.decorations.hunk-header-line-number-style "#067a00"
        git config --global stash.showIncludeUntracked true # show untracked files in stash
        git config --global push.default upstream           # using symmetric push and pull for lazygit
        ;;
    *)
        echo "setting git diff for $1"
        git-nbdiffdriver config --enable --global
        git-nbdifftool config --enable --global
        ;;
    esac
}

function link_configs() {
    create_symlink "$HOME/.dotfiles/gitConfig/gh-dash" "$HOME/.config/gh-dash"
    create_symlink "$HOME/.dotfiles/gitConfig/lazygit/config.yml" "$HOME/Library/Application Support/lazygit/config.yml"
}

get_completion
add_to_rc_file
link_configs
add_git_aliases "$@"
