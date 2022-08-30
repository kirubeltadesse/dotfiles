# dotfiles

## WSL configuration

WSL proper configuration will give you a great overall workflow. Especially, wsl2 having Docker Disktop running natively enhance the overall productivity. There are useful information on how to mount and unmont drivers on WSL
[link](https://linuxnightly.com/mount-and-access-hard-drives-in-windows-subsystem-for-linux-wsl/)

## Setup Process

This is a current setup process for the `dotfiles`. In the future, I plan to use a [utility](https://www.chezmoi.io/user-guide/setup/) tool to handle this process. For now, first clone the repo and rename the folder

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

- [x] alias for wsl terminal clip
- [ ] cd completion configuration
- [ ] gitconfig

## Checklist for backing up

- [ ] project to github
- [ ] git alias backedup
- [ ] 

---

<details>

<summary> FAQ </summary>

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

NOTE: copying from wsl to cmd.exe easy works

ANS: [here](https://devblogs.microsoft.com/commandline/sharing-ssh-keys-between-windows-and-wsl-2/)

</details>
