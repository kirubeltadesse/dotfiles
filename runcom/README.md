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

## Installation requirements

### statusbar tmux-powerline

use this [link](https://github.com/edkolev/tmuxline.vim#installation) to directly copy the file

clone this [repo](https://github.com/erikw/tmux-powerline) to your HOME directory To have a similar-looking status bar line to the vim status bar we need to have the `tmuxline.vim` in our Pathogen bundle.

### Install fzf

### Install BAT

### Install Nerdtree

## cheat sheet

- `C+A ALT+1`: Even horizontal splits
- `C+A ALT+2`: Even vertical splits
- `C+A ALT+3`: Horizontal span for the main pane, vertical splits for lesser panes
- `C+A ALT+3`: Vertical span for the main pane, horizontal splits for lesser panes
- `C+A ALT+5`: Tiled layout

### pane

`C+A !`: break out a panel

[Here](https://blog.sanctum.geek.nz/vi-mode-in-tmux/#:~:text=Most%20of%20the%20basic%20vi,another%2C%20and%20then%20pressing%20Enter.) good resource on how to set up vi modes for tmux

