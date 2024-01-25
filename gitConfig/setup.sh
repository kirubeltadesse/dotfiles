folder="$HOME/.dotfiles"
source $folder/utility/utilities.sh

print warning "Installing git completion"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o ~/.git-completion.bash

# Check if the download was successful
if [ $? -eq 0 ]; then
	print warning "Downlaod successful."

	# Make the downloaded file executable
	print warning "Making it executable"
	chmod +x ~/.git-completion.bash
	if [ $? -eq 0 ]; then
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
text="
if [ -f ~/.git-completion.bash ]; then
	. ~/.git-completion.bash
fi

"

while IFS= read -r line; do
	append_line 1 "${line}" "${filebashprofile}"
done <<< "$text"

filebashrc="$HOME/.bashrc"
text="
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g 2>/dev/null \
	complete -o default -o nospace -F __git_wrap__git_main g
"

print warning "Adding bash complete for git alias line to .bashrc"
while IFS= read -r line; do
	append_line 1 "${line}" "${filebashrc}"
done <<< "$text"



# creating alias for git
print warning "setup up git shortcuts"

# this is more formal way to create the git alias
# https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases
git config --global branch.autosetuprebase always
git config --global alias.a add
git config --global alias.co checkout
git config --global alias.b branch
git config --global alias.c commit
git config --global alias.cp cherry-pick
git config --global alias.d diff
git config --global alias.f fetch 
git config --global alias.last 'log -1 HEAD'
git config --global alias.logauth 'log --author'
git config --global alias.logdog 'log --decorate --oneline --graph'
git config --global alias.logs 'log --stat'
git config --global alias.m merge
git config --global alias.ps push
git config --global alias.pl pull
git config --global alias.r remote
git config --global alias.rb rebase
git config --global alias.rba 'rebase --abort'
git config --global alias.rbc 'rebase --continue'
git config --global alias.rs restore
git config --global alias.rss 'restore --staged'
git config --global alias.w 'show'
git config --global alias.sno 'show --name-only'
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

# add this git configuration for MacOs, windows and SunOS
# if [[ "$os" == "Darwin" || "$os" == "Linux" || "$os" == "SunOS" ]]; then
if [ $# -eq 0 ]; then
	# setting vim for git tool
 	git config --global diff.tool vimdiff
	git config --global merge.tool vimdiff
	git config --global core.excludesFile "${HOME}/.dotfiles/gitConfig/gitignore"
else
	local env=$1
	echo "setting git diff for $1"
	git config --global core.editor vi
	git-nbdiffdriver config --enable --global
	git-nbdifftool config --enable --global
fi

# Additional Git config settings here

