# VScode configuration

## Update list of installed plugins

Linking VScode [locally](https://stackoverflow.com/questions/57868950/wsl2-terminal-does-not-recognize-visual-studio-code)
`/c/Program\ Files/Microsoft\ VS\ Code/bin/code /home/ktadesse1/.local/bin`


To update the list of installed plugins (the `extensions` file by running the following script:

```bash
code --list-extensions >> extensions
```

NOTE: you need to remove the duplications

[Here](/vscode/settings.json) is my preferred vscode `settings.json` file

### Keybindings and settings

Inside the extension installing script there is copy bash statement that directly copy the
to the location where vscode is expecting to get the `settings.json` and `keybindings.json` files

### Formatting

Under `Workspace` search for Formatting and check `Format On Save`

Make sure the `prettier` is selected under `Text` in side the `Workspace`

### Font Settings

In the workspace, you should set the `Font Family` to `Cascadia Code, Fira Code`

### Todo Tree

By default should have `BUG`, `HACK`, `FIXME`, and `TODO`

## Intellij to VSCode shortcuts keys

First make sure the idea extensions is installed on the VScode.

This is really helpful to have some similar functionality across VScode and Intellij. Go to **File** :point_right: **Manage IDE Settings** :point_right: **Export Settings**, and select just **Keymaps (schemes)**

### Usage

- Launch code
- Open command pallet `Ctrl-Shift-P` or `Cmd-Shift-P`
- Choose _Import Intellij Keybindings (XML)_
- Copy & Paste it into `keybindings.json`


---

<details>

<summary> FAQ working with vs code </summary>

- `code .` is not openning on `wsl`

- ANS: Linking VScode [locally](https://stackoverflow.com/questions/57868950/wsl2-terminal-does-not-recognize-visual-studio-code)

</details>

Here is my preferred vscode `settings.json` file
