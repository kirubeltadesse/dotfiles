# creating alias for git 

echo "setup up git shortcuts"
git config --global alias.last 'log -1 HEAD'
git config --global alias.logdog 'log --decorate --oneline --graph'
git config --global alias.sno 'show --name-only'

# TODO: add this information
# git config --global alias.logauth 'log --author= {name}'

# setting vim for git tool
git config --global diff.tool vimdiff
git config --global merge.tool vimdiff
