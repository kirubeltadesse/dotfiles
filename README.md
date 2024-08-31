# Dotfiles


## WSL configuration

WSL's proper configuration will give you a great overall workflow. Significantly, wsl2 having Docker Desktop running naively enhances the overall productivity. There is valuable information on how to mount and `unmont` drivers on WSL
[link](https://linuxnightly.com/mount-and-access-hard-drives-in-windows-subsystem-for-linux-wsl/)

## Setup Process

This is a current setup process for the `dotfiles`. In the future, I plan to use a [utility](https://www.chezmoi.io/user-guide/setup/) tool to handle this process. First, clone the repo, rename the folder, and run the installer script to ensure it is executable. If not, use `chmod +x install.sh` command

```bash
./install.sh
```

## Setting up Application

Using [chocolatey](https://chocolatey.org/) install software to your windows

- Git/GitHub
- WSL
- VScode
- Vimium extension setting

## TMUX and Vim
[Here](/runcom/README.md) are detailed instructions on how to set up Tmux and Vim.

## Browser

[Here](/browser/chrome/README.md) is a detail information about to add plugins to your browser.

## Checklist for backing up

### Local stashed changes

1. Creating the stash as a patch

```bash
git stash show "stash@{0}" -p -u > changes.patch
```

2. Create a branch and push the patch file
3. Pull the branch on the new computer
4. and apply the patch file

```bash
git apply changes.patch
```

If there is a mistake and you want to reverse the change

```bash
git apply changes.patch --reverse
```

If you are getting an error that says

> can't find file to patch

Navigate to the git root directory and run the command

If error with white spaces run one of this options:

1. `git apply --reject --whitespace=fix my-patch.patch` - partly works
but creates rej hunks
1. `git apply --reject --ignore-whitespace --whitespace=fix my-patch.patch` - same as above
1. `git am -3 --ignore-whitespace` - patch format detection failed
1. `git apply -3 --ignore-whitespace1` - fails with trailing white space
and new blank line at EOF.


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

### Ques: Is git status slow in WSL2?

ANS:

The NTFS is fast on Windows than WLS2 (Linux system). Therefore, the solution is to put to the Windows git system in `.profile`

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

</details>

ANS: [here](https://devblogs.microsoft.com/commandline/sharing-ssh-keys-between-windows-and-wsl-2/)

## More
