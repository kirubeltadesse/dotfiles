# dotfiles

# Setup Process
In the `.bashrc` you should copy the following code. 
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

for DOTFILE in "$DOTFILES_DIR"/system/.{alias,env};
do
        [ -f "$DOTFILE" ] && . "$DOTFILE"
done

```

# using uname with flags to identify the shell evironment

### Configureation to work on 
 - [X] Understand the difference between interactive and non-interactive shell
 - [X] alias for wsl terminal clip 
 - [X] tmux configuration
 - [ ] vim airline plugin 
 - [ ] cd completetion configuration 
 - [ ] gitconfig  



