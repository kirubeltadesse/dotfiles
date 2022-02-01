# dotfiles

## WSL configuration

WSL proper configuration will give you a great overall workflow. Especially, wsl2 having Docker Disktop running natively enhance the overall productivity. There are useful information on how to mount and unmont drivers on WSL
[link](https://linuxnightly.com/mount-and-access-hard-drives-in-windows-subsystem-for-linux-wsl/)

## Setup Process

This is a current setup process for the `dotfiles`. In the future, I plan to use a utility tool to handle this process. For now, first clone the repo and rename the folder

```bash
mv dotfiles .dotfiles
```

Then, in the `.bashrc` you should copy the following code. for the `system` script there needs to be a linker
<!--
One for the `runcom` level configurations
 ```bash
DOTFILES_DIR="$HOME/.dotfiles"

for DOTFILE in "$DOTFILES_DIR"/runcom/.{bash_profile,};
do
        [ -f "$DOTFILE" ] && . "$DOTFILE"
done

``` -->

```bash
DOTFILES_DIR="$HOME/.dotfiles"

for DOTFILE in "$DOTFILES_DIR"/system/.{alias,env,function};
do
        [ -f "$DOTFILE" ] && . "$DOTFILE"
done

```

## Setting up Application

Using [chocolatey](https://chocolatey.org/) install softwares to your windows

- Git/GitHub
- wsl
- VScode

Installed

- Installed Pathogen from vim-airline
- [https://github.com/vim-airline/vim-airline] vim-airline
- Install tmux vim-airline

## Configuration to work on

- [X] alias for wsl terminal clip
- [ ] cd completion configuration
- [ ] gitconfig

## More
