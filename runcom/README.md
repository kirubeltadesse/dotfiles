# Run command information

After making a change to the `.tmux.conf` file you will need to source it using the command

```bash
tmux source ~/.tmux.conf
```

or you can use the `r` for easy config reloads. If this doesn't reflect the change, try using

```bash
tmux kill-server && tmux
```

To know your tmux version you can use this shortcut

```bash
tmux -V
```

There is a good resource for tmux

```bash
man tmux
```

To capture more history

```bash
tmux capture-pane -pS -1000000
```

- `Prefix + c`: create new window
- `Prefix + n/p`: next/previous new window
- `Prefix ALT+1`: Even horizontal splits
- `Prefix ALT+2`: Even vertical splits
- `Prefix ALT+3`: Horizontal span for the main pane, vertical splits for lesser panes
- `Prefix ALT+4`: Vertical span for the main pane, horizontal splits for lesser panes
- `Prefix ALT+5`: Tiled layout
- `Prefix + L`: last session


### pane

`C+A !`: break out a panel

[Here](https://blog.sanctum.geek.nz/vi-mode-in-tmux/#:~:text=Most%20of%20the%20basic%20vi,another%2C%20and%20then%20pressing%20Enter.) good resource on how to set up vi modes for tmux


## Installation requirements


### statusbar tmux-powerline

use this [link](https://github.com/edkolev/tmuxline.vim#installation) to directly copy the file

clone this [repo](https://github.com/erikw/tmux-powerline) to your HOME directory To have a similar-looking status bar line to the vim status bar we need to have the `tmuxline.vim` in our Pathogen bundle.

You can find all the bind shourtcut using

`C+a ?`
`tmux list-keys` or `tmux lsk` in shell inside tmux
In tmux's command prompt(`C + a :`) list-keys or lsk

[here](https://www.seanh.cc/2020/12/28/binding-keys-in-tmux/)

There is also `tpm` [Here](https://github.com/tmux-plugins/tpm) all the installation command are also found in the page.

`prefix + I`

It will be awesome if the tmux navigation is more like vim 😊 [Here](https://www.bugsnag.com/blog/tmux-and-vim)


## Vim installation

Your `.vimrc` file already contains the package that needs to be installed. For example, `fzf`, `Nerdtree`

Download plug.vim using

```bash
curl ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

then inside the vim file run the command `:PlugInstall`

[checksheets](https://www.maketecheasier.com/cheatsheet/vim-keyboard-shortcuts/)

Debugging tips:

Start by viewing the key code your terminal is sending to vim:

`$ sed -n l`

Then you can use the notation in your command

## NeoVim Installation

Getting Packer

```
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```

Make sure to install all the package using `:PackerSync` inside the the `~/.config/nvim/directory` 


