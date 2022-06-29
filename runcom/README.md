# Run command information

After making change to the `.tmux.conf` file you will need to source it using the commend

```bash
tmux source ~/.tmux.conf
```

or you can use the `r` for easy config reloads. If this doesn't reflect the change, try to use restarting the tmux server

```bash
tmux kill-server && tmux
```

To know you tmux version you can use this shortcut 

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


## cheat sheet



- `C+A ALT+1` : Even horizontal splits
- `C+A ALT+2` : Even vertical splits
- `C+A ALT+3` : Horizontal span for the main pane, vertical splits for lesser panes
- `C+A ALT+3` : Vertical span for the main pane, horizontal splits for lesser panes
- `C+A ALT+5` : Tiled layout 

### pane

- `C+A !` : break out a panel


[Here](https://blog.sanctum.geek.nz/vi-mode-in-tmux/#:~:text=Most%20of%20the%20basic%20vi,another%2C%20and%20then%20pressing%20Enter.) good resource how to setup vi mode for tmux 

