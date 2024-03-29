# dotfiles

## WSL configuration

WSL proper configuration will give you a great overall workflow. Especially, wsl2 having Docker Disktop running natively enhance the overall productivity. There are useful information on how to mount and unmont drivers on WSL
[link](https://linuxnightly.com/mount-and-access-hard-drives-in-windows-subsystem-for-linux-wsl/)

## Setup Process

This is a current setup process for the `dotfiles`. In the future, I plan to use a [utility](https://www.chezmoi.io/user-guide/setup/) tool to handle this process. For now, first clone the repo and rename the folder

```bash
mv dotfiles .dotfiles
```

and run the installer script make sure it is executable. If not, use `chmod +x install.sh` command

```bash
./install.sh
```

## Setting up Application

Using [chocolatey](https://chocolatey.org/) install softwares to your windows

- Git/GitHub
- wsl
- VScode
- vimium extension setting

Installed

- Installed Pathogen from vim-airline
- [https://github.com/vim-airline/vim-airline] vim-airline
- Install tmux vim-airline
- manually load the `vimium-options.json` on the vimium setting

## Configuration to work on

- [x] alias for wsl terminal clip
- [ ] cd completion configuration
- [ ] gitconfig

## Checklist for backing up

### Local stashed changes

1. Creating the stash as a patch

```
git stash show "stash@{0}" -p -u > changes.patch 
```

2. Create a branch and push the patch file
3. Pull the branch on the new computer
4. and apply the patch file

```
git apply changes.patch
```

If there is mistake and you want to reverse the change

```
git apply changes.patch --reverse
```

If you are getting an error out that says

> can't find file to patch

Navigate to the git root directory and run the command

---

<details>

<summary> FAQ </summary>

### iTem2

preferences->profiles->Command (Custom Shell) -> add `/bin/bash`

you can also set that as a default [shell](https://www.howtogeek.com/444596/how-to-change-the-default-shell-to-bash-in-macos-catalina/)

### Ques: Cloning error ?

```bash
error: chmod on /c/*/.git/config.lock failed: Operation not permitted
fatal: could not set 'core.filemode' to 'false'
```

ANS:

```bash
sudo umount /mnt/c
sudo mount -t drvfs C: /mnt/c -o metadata
```

For more information: [Here](https://askubuntu.com/questions/1115564/wsl-ubuntu-distro-how-to-solve-operation-not-permitted-on-cloning-repository)

### Ques: git status is slow in WSL2 ?

ANS:

The NTFS is fast on windows than wls2 ( linux system). Therefore the solution is to pit to the windows git system in `.profile`

```bash
# checks to see if we are in a windows or linux dir
function isWinDir {
  case `pwd -P`/ in
    /c/*) return $(true);;
    *) return $(false);;
  esac
}
# wrap the git command to either run windows git or linux
function git {
  if isWinDir
  then
    git.exe "$@"
  else
    /usr/bin/git "$@"
  fi
}

```

### Sharing `.ssh` between `wsl2` and windows `cmd.exe`

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

- [x] alias for wsl terminal clip
- [ ] cd completion configuration
- [ ] # gitconfig

# using uname with flags to identify the shell evironment

### Configureation to work on

- [x] Understand the difference between interactive and non-interactive shell
- [x] alias for wsl terminal clip
- [x] tmux configuration if copy pasting formate
- [ ] vim airline plugin
- [ ] cd completion configuration
- [ ] gitconfig

NOTE: copying from wsl to cmd.exe easy works

ANS: [here](https://devblogs.microsoft.com/commandline/sharing-ssh-keys-between-windows-and-wsl-2/)

</details>

## More
