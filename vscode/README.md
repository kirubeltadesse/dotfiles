# VScode configuration

## Update list of installed plugins


Linking VScode (locally)[https://stackoverflow.com/questions/57868950/wsl2-terminal-does-not-recognize-visual-studio-code]

 /c/Program\ Files/Microsoft\ VS\ Code/bin/code /home/ktadesse1/.local/bin



# Update list of installed plugins
To update the list of installed plugins (the `extenstions` file by running the following script:

```bash
code --list-extensions >> extensions
```

NOTE: you need to remove the duplications

[Here](/vscode/settings.json) is my preferred vscode `settings.json` file

## Keybindings and settings

Inside the extension installing script there is copy bash statement that directly copy the
to the location where vscode is expecting to get the `settings.json` and `keybindings.json` files

## Formatting

Under `Workspace` search for Formatting and check `Format On Save`

Make sure the `prettier` is selected under `Text` in side the `Workspace`

## Font Settings

In the workspace, you should set the `Font Family` to `Cascadia Code, Fira Code`

## Todo Tree

By default should have `BUG`, `HACK`, `FIXME`, and `TODO`

---

<details>

<summary> FAQ working with vs code </summary>

- `code .` is not openning on `wsl`

- ANS: Linking VScode [locally](https://stackoverflow.com/questions/57868950/wsl2-terminal-does-not-recognize-visual-studio-code)

</details>
