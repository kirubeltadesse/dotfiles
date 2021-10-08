# dotfiles

# Setup Process

In the `.profile` you should copy the following code
```

DOTFILES_DIR="$HOME/.dotfiles"

for DOTFILE in "$DOTFILES_DIR"/system/.{alias,};
do
        [ -f "$DOTFILE" ] && . "$DOTFILE"
done

```

# using uname with flags to identify the shell evironment

### Configureation to work on 

 - [ ] tmux configuration
 - [ ] cd completetion configuration 
 - [ ] vim airline plugin 
 - [ ] alias for wsl terminal clip 



