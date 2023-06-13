# creating alias for git 

echo "setup up git shortcuts"

# this is more formal way to create the git alias
# https://git-scm.com/book/en/v2/Git-Basics-Git-Aliases

git config --global alias.a add 
git config --global alias.co checkout 
git config --global alias.b branch
git config --global alias.c commit 
git config --global alias.cp cherry-pick
git config --global alias.d diff 
git config --global alias.last 'log -1 HEAD'
git config --global alias.logauth 'log --author'
git config --global alias.logdog 'log --decorate --oneline --graph'
git config --global alias.m merge 
git config --global alias.ps push 
git config --global alias.pl pull 
git config --global alias.r remote 
git config --global alias.sa 'stash apply' 
git config --global alias.sc 'stash clear' 
git config --global alias.sd 'stash drop' 
git config --global alias.sl 'stash list'
git config --global alias.sp 'stash pop' 
git config --global alias.ss 'stash save' 
git config --global alias.st status 
git config --global alias.sw 'stash show' 
git config --global alias.sno 'show --name-only'

# Get the name 
os=$(uname)

# add this git configuration for MacOs, windows and SunOS
# if [[ "$os" == "Darwin" || "$os" == "Linux" || "$os" == "SunOS" ]]; then
if [ $# -eq 0 ]; then
	# setting vim for git tool
 	git config --global diff.tool vimdiff
	git config --global merge.tool vimdiff
else
	local env=$1
	echo "setting git diff for $1"
	git config --global core.editor vi
	git-nbdiffdriver config --enable --global
	git-nbdifftool config --enable --global
fi

