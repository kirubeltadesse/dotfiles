After making change to the `.tmux.conf` file you will need to source it using the commend
```
tmux source ~/.tmux.conf
```
or you can use the `r` for easy config reloads. If this doesn't reflect the change, try to use restarting the tmux server
```
tmux kill-server && tmux 
```
