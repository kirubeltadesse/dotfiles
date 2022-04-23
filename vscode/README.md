
Linking VScode (locally)[https://stackoverflow.com/questions/57868950/wsl2-terminal-does-not-recognize-visual-studio-code]

 /c/Program\ Files/Microsoft\ VS\ Code/bin/code /home/ktadesse1/.local/bin



# Update list of installed plugins
To update the list of installed plugins (the `extenstions` file by running the following script:

```
code --list-extensions >> extensions
```
NOTE: you need to remove the duplications

Here is my preferred vscode `settings.json` file

```
{
"workbench.colorTheme": "Abyss",
    "workbench.editorAssociations": {
        "*.ipynb": "jupyter-notebook"
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
            "before": [
                "j",
                "j"
            ],
            "after": [
                "<Esc>"
            ]
        }
    ],
    "vim.normalModeKeyBindingsNonRecursive": [
        {
            "before": [
                "<leader>",
                "d"
            ],
            "after": [
                "d",
                "d"
            ]
        },
        {
            "before": [
                "<C-n>"
            ],
            "commands": [
                ":nohl"
            ]
        }
    ],
    "vim.leader": "<space>",
    "vim.handleKeys": {
        "<C-a>": false,
        "<C-f>": false
    },
    "vim.statusBarColorControl": true,
    "vim.statusBarColors.normal": [
        "#8FBCBB",
        "#434C5E"
    ],
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
    "workbench.editor.untitled.hint": "hidden"
}
```













