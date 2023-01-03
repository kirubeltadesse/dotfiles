# creating alias for git 

echo "setup up git shortcuts"
git config --global alias.last 'log -1 HEAD'
git config --global alias.logdog 'log --decorate --oneline --graph'
git config --global alias.sno 'show --name-only'

# TODO: add this information
# git config --global alias.logauth 'log --author= {name}'


echo "check the os"

# Get the name 
os=$(uname)

# FIXME: add windows os 
if[ "$os" == "Darwin" ]; then
	# setting vim for git tool
 	git config --global diff.tool vimdiff
	git config --global merge.tool vimdiff
else
	echo "setting git diff for notebook"
	git-nbdiffdriver config --enable --global
	git-nbdifftool config --enable
fi

