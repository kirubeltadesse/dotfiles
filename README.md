# dotfiles

# Setup Process

first clone the repo and rename the folder

```
mv dotfiles .dotfiles
```

Then, In the `.bashrc` you should copy the following code. 
for the `runcom` script there needs to be a linker
```
DOTFILES_DIR="$HOME/.dotfiles"

for DOTFILE in "$DOTFILES_DIR"/runcom/.{,};
do
        [ -f "$DOTFILE" ] && . "$DOTFILE"
done

```

One for the system level configurations

```

DOTFILES_DIR="$HOME/.dotfiles"

for DOTFILE in "$DOTFILES_DIR"/system/.{alias,env,function};
do
        [ -f "$DOTFILE" ] && . "$DOTFILE"
done

```

# using uname with flags to identify the shell evironment

# [https://chocolatey.org/] installing Choco to windows


# Setting up Application 
Using chocolately install
 - Git/GitHub
 - wsl
 - VScode

Installed 
	- Installed Pathogen from vim-airline  
	- [https://github.com/vim-airline/vim-airline] vim-airline
	- Install tmux vim-airline


### Configureation to work on 
 - [X] Understand the difference between interactive and non-interactive shell
 - [X] alias for wsl terminal clip 
 - [X] tmux configuration if copy pasting formate
 - [X] vim airline plugin 
 - [ ] cd completetion configuration 
 - [ ] gitconfig  

## More:
 * Understand how the some software on GitHub have release code ?
 * Understand how issue doc work on GitHub ? 
 
