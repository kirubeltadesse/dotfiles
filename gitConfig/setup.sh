#!/bin/bash

source "$HOME"/.dotfiles/utility/utilities.sh

print warning "Installing git completion"

# Check if the download was successful
if ! curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash; then
	print warning "Downlaod successful."

	# Make the downloaded file executable
	print warning "Making it executable"
	if ! chmod +x ~/.git-completion.bash; then
		print "warning" "File is now executable."
	else
		print "error" "Error: Failed to make the file executable."
	fi
else
	print "error" "Error: Download failed."
fi

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
text="
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g 2>/dev/null \
	complete -o default -o nospace -F __git_wrap__git_main g
"

print warning "Adding bash complete for git alias line to .bashrc"
while IFS= read -r line; do
	append_line 1 "${line}" "${filebashrc}"
done <<<"$text"

# creating alias for git
print warning "setup up git shortcuts"

# this is more formal way to create the git alias
# https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases
git config --global init.defaultBranch main
git config --global branch.autosetuprebase always
git config --global alias.a add
git config --global alias.co checkout
git config --global alias.b branch
git config --global alias.c commit
git config --global alias.cp cherry-pick
git config --global alias.d diff
git config --global alias.f fetch
git config --global alias.last 'log -1 HEAD'
git config --global alias.loga 'log --author'
git config --global alias.logba 'log --branches --author'
git config --global alias.logbna 'log --branches --no-walk --author'
git config --global alias.logboa 'log --branches --oneline --author'
git config --global alias.logdog 'log --decorate --oneline --graph'
git config --global alias.logs 'log --stat'
git config --global alias.m merge
git config --global alias.ps push
git config --global alias.pl pull

echo "----------------------------------- remote -----------------------------------"

git config --global alias.r remote
git config --global alias.ra 'remote add'
git config --global alias.rr 'remote rm'
git config --global alias.rv 'remote -v'
git config --global alias.rn 'remote rename'
git config --global alias.rs 'remote show'

echo "----------------------------------- rebase -----------------------------------"

git config --global alias.rb rebase
git config --global alias.rba 'rebase --abort'
git config --global alias.rbc 'rebase --continue'
git config --global alias.rbi 'rebase --interactive'
git config --global alias.rbs 'rebase --skip'

echo "----------------------------------- reset -----------------------------------"

git config --global alias.re 'reset'
git config --global alias.rh 'reset HEAD'
git config --global alias.reh 'reset --hard'
git config --global alias.rem 'reset --mixed'
git config --global alias.res 'reset --soft'
git config --global alias.rehh 'reset --hard HEAD'
git config --global alias.remh 'reset --mixed HEAD'
git config --global alias.resh 'reset --soft HEAD'
git config --global alias.rehom 'reset --hard origin/master'

echo "----------------------------------- restore -----------------------------------"

git config --global alias.rs restore
git config --global alias.rss 'restore --staged'
git config --global alias.w 'show'
git config --global alias.wno 'show --name-only'

echo "----------------------------------- stash -----------------------------------"

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

# Get the name
os=$(uname)

# TODO: install brew install git-delta
# https://dandavison.github.io/delta/configuration.html
# add the delta configuration to the script 

# add this git configuration for MacOs, windows and SunOS
if [[ "$os" == "Darwin" || "$os" == "Linux" || "$os" == "SunOS" ]]; then
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
	git config --global delta.interactive.keep-plus-minus-markers false
	git config --global delta.decorations.commit-decoration-style "blue ol"
	git config --global delta.decorations.hunk-header-decoration-style "blue box"
	git config --global delta.decorations.hunk-header-file-style red
	git config --global delta.decorations.hunk-header-style "file line-number syntax"
	git config --global delta.decorations.hunk-header-line-number-style "#067a00"
	
else
	echo "setting git diff for $1"
	git config --global core.editor vi
	git-nbdiffdriver config --enable --global
	git-nbdifftool config --enable --global
fi

# Additional Git config settings here
