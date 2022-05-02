# VScode configuration

## Update list of installed plugins

To update the list of installed plugins (the `extenstions` file by running the following script:

```bash
code --list-extensions >> extensions
```

NOTE: you need to remove the duplications

Here is my preferred vscode `settings.json` file

```JSON
"workbench.colorTheme": "Abyss",
  "workbench.editorAssociations": {
    "*.ipynb": "jupyter-notebook",
    "*.exe": "default"
  },
  "cmake.configureOnOpen": true,
  "diffEditor.ignoreTrimWhitespace": false,
  "notebook.cellToolbarLocation": {
    "default": "right",
    "jupyter-notebook": "left"
  },
  "vim.easymotion": true,
  "vim.surround": true,
  "vim.incsearch": true,
  "vim.useSystemClipboard": true,
  "vim.useCtrlKeys": true,
  "vim.hlsearch": true,
  "vim.insertModeKeyBindings": [
    {
      "before": ["j", "j"],
      "after": ["<Esc>"]
    }
  ],
  "vim.normalModeKeyBindingsNonRecursive": [
    {
      "before": ["<leader>", "d"],
      "after": ["d", "d"]
    },
    {
      "before": ["<C-n>"],
      "commands": [":nohl"]
    }
  ],
  "vim.leader": "<space>",
  "vim.handleKeys": {
    "<C-a>": false,
    "<C-f>": false
  },
  "vim.statusBarColorControl": true,
  "vim.statusBarColors.normal": ["#8FBCBB", "#434C5E"],
  "vim.statusBarColors.insert": "#BF616A",
  "vim.statusBarColors.visual": "#B48EAD",
  "vim.statusBarColors.visualline": "#B48EAD",
  "vim.statusBarColors.visualblock": "#A3BE8C",
  "vim.statusBarColors.replace": "#D08770",
  "vim.statusBarColors.commandlineinprogress": "#007ACC",
  "vim.statusBarColors.searchinprogressmode": "#007ACC",
  "vim.statusBarColors.easymotionmode": "#007ACC",
  "vim.statusBarColors.easymotioninputmode": "#007ACC",
  "vim.statusBarColors.surroundinputmode": "#007ACC",
  "workbench.colorCustomizations": {
    "statusBar.background": "#B48EAD",
    "statusBar.noFolderBackground": "#B48EAD",
    "statusBar.debuggingBackground": "#B48EAD",
    "statusBar.foreground": "#434C5E",
    "statusBar.debuggingForeground": "#434C5E"
  },
  "vim.easymotionMarkerForegroundColorOneChar": "yellow",
  "vim.foldfix": true,
  "workbench.editor.untitled.hint": "hidden",
  "editor.suggestSelection": "first",
  "vsintellicode.modify.editor.suggestSelection": "automaticallyOverrodeDefaultValue",
  "editor.largeFileOptimizations": false,
  "workbench.iconTheme": "material-icon-theme",
  "editor.fontLigatures": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnPaste": true,
  "editor.formatOnSave": true,
  "prettier.enable": true,
  "prettier.arrowParens": "always",
  "prettier.bracketSpacing": true,
  "html.format.templating": true,
  "window.zoomLevel": 1
}
```

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
