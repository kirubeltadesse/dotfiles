return {
  "tpope/vim-surround",
  event = "VeryLazy",
  dependencies = {
    "tpope/vim-repeat",
  },
  config = function()
    -- LazyVim's `editor.leap` extra (leap.nvim) maps `s`/`S` in every mode,
    -- which hijacks vim-surround's `ys`/`S`. Reclaim `s`/`S` for surround.
    -- Leap-style jumps remain available via flit's labeled `f`/`F`/`t`/`T`.
    for _, mode in ipairs({ "n", "x", "o" }) do
      pcall(vim.keymap.del, mode, "s")
      pcall(vim.keymap.del, mode, "S")
    end
    vim.keymap.set("n", "ds", "<Plug>Dsurround", { remap = true, silent = true })
    vim.keymap.set("n", "cs", "<Plug>Csurround", { remap = true, silent = true })
    vim.keymap.set("n", "cS", "<Plug>CSurround", { remap = true, silent = true })
    vim.keymap.set("n", "ys", "<Plug>Ysurround", { remap = true, silent = true })
    vim.keymap.set("n", "yS", "<Plug>YSurround", { remap = true, silent = true })
    vim.keymap.set("n", "yss", "<Plug>Yssurround", { remap = true, silent = true })
    vim.keymap.set("x", "S", "<Plug>VSurround", { remap = true, silent = true })
    vim.keymap.set("x", "gS", "<Plug>VgSurround", { remap = true, silent = true })
  end,

  --   Surround.vim is all about "surroundings": parentheses, brackets, quotes, XML tags, and more.
  --   The plugin provides mappings to easily delete, change and add such surroundings in pairs.
  --
  --    It's easiest to explain with examples. Press cs"' inside
  -- "Hello world!"
  --
  --    to change it to
  -- 'Hello world!'
  --
  --    Now press cs'<q> to change it to
  -- <q>Hello world!</q>
  --
  --    To go full circle, press cst" to get
  -- "Hello world!"
  --
  --    To remove the delimiters entirely, press ds".
  -- Hello world!
  --
  --    Now with the cursor on "Hello", press ysiw] (iw is a text object).
  -- [Hello] world!
  --
  --    Let's make that braces and add some space (use } instead of { for no space): cs]{
  -- { Hello } world!
  --
  --    Now wrap the entire line in parentheses with yssb or yss).
  -- ({ Hello } world!)
  --
  --    Revert to the original text: ds{ds)
  -- Hello world!
  --
  --    Emphasize hello: ysiw<em>
  -- <em>Hello</em> world!
  --
  --    Finally, let's try out visual mode. Press a capital V (for linewise visual mode) followed by S<p class="important">.
  -- <p class="important">
  --   <em>Hello</em> world!
  -- </p>
  --
}
