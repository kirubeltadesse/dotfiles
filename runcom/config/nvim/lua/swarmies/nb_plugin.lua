local Snacks = require("snacks")

local M = {}

-- Get the current notebook from the .current file
local function get_current_notebook_path()
  local notebook_path = vim.fn.expand("~/.nb/") .. vim.fn.trim(vim.fn.readfile(vim.fn.expand("~/.nb/.current"))[1])
  return notebook_path
end

M.nb_open_encrypted = function()
  local notebook_path = get_current_notebook_path()
  if notebook_path and vim.fn.isdirectory(notebook_path) == 1 then
    Snacks.picker.files({ cwd = notebook_path })
  else
    Snacks.notifier.notify("📁 No active notebook found!", "warn")
    return
  end

  -- List encrypted notes
  local handle = io.popen("find " .. vim.fn.shellescape(notebook_path) .. " -type f -name '*.enc'")
  if not handle then
    Snacks.notifier.notify("❌ Failed to list encrypted notes!", "error")
    return
  end

  local results = {}
  for line in handle:lines() do
    table.insert(results, line)
  end
  handle:close()

  Snacks.picker.select({
    items = results,
    prompt = "🔒 Encrypted Notes: ",
    on_choice = function(file)
      if not file then
        return
      end
      -- Ask for decryption password (hidden input)
      local password = vim.fn.inputsecret("Enter password to decrypt " .. file .. ": ")

      -- Run decryption synchronously
      local handle =
        io.popen(string.format("openssl enc -d -aes-256-cbc -md sha256 -in '%s' -pass pass:'%s'", file, password))
      if not handle then
        Snacks.notifier.notify("❌ Failed to decrypt file: " .. file, "error")
        return
      end

      local decrypted_content = handle:read("*a")
      handle:close()

      if decrypted_content == "" then
        Snacks.notifier.notify("❌ Failed to decrypt file: " .. file, "error")
        return
      end

      vim.schedule(function()
        -- Open the encrypted file but set the decrypted content
        vim.cmd("edit " .. vim.fn.fnameescape(file))

        local buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(decrypted_content, "\n"))

        -- Mark buffer as modified
        vim.bo.modified = true

        -- Store encryption password (TEMPORARY, use with caution)
        vim.api.nvim_buf_set_var(buf, "encryption_password", password)

        -- Hook into save to re-encrypt
        vim.api.nvim_create_autocmd("BufWriteCmd", {
          buffer = buf,
          callback = function()
            local enc_file = vim.api.nvim_buf_get_name(buf)
            local save_password = vim.api.nvim_buf_get_var(buf, "encryption_password")

            -- Write decrypted content to a temp file
            local tmpfile = vim.fn.tempname()
            vim.api.nvim_exec("write! " .. tmpfile, false)

            -- Encrypt and overwrite original file
            local encrypt_cmd = string.format(
              "openssl enc -aes-256-cbc -md sha256 -in '%s' -out '%s' -pass pass:'%s'",
              tmpfile,
              enc_file,
              save_password
            )
            os.execute(encrypt_cmd)
            os.remove(tmpfile)

            Snacks.notifier.notify("✅ File encrypted and saved: " .. enc_file, "info")

            -- Close the buffer after saving
            vim.api.nvim_buf_delete(buf, { force = true })
          end,
        })

        Snacks.notifier.notify("✅ Editing encrypted file: " .. file, "info")
      end)
    end,
  })
end

-- Custom function to browse nb notes
M.nb_find_files = function()
  local notebook_path = get_current_notebook_path()

  if notebook_path == "" then
    Snacks.notifier.notify("📁 No active notebook found!", "warn")
    return
  end

  Snacks.picker.files({
    prompt = "📚 NB Notes: ",
    cwd = notebook_path, -- Set FZF to search inside the current notebook
    hidden = true,
    follow = true,
    file_ignore_patterns = { "%.lock$", "%.log$", "%.swp$", "%.DS_Store", "%.git", ".obsidian" },
    -- can you handle the ecrypted files?
  })
end

-- Function to search through contents of your notes
M.nb_live_grep = function()
  local notes_directory = get_current_notebook_path()

  Snacks.picker.grep({
    prompt = "🔭 NB> ", -- Title for the search prompt
    cwd = notes_directory, -- Set the current working directory to your notes folder
    hidden = true, -- Include hidden files in the search
    file_ignore_patterns = { "%.lock$", "%.log$", "%.swp$", "%.DS_Store" }, -- Ignore unnecessary files
  })
end

-- Custom function to search for notes in all notebooks
M.nb_notes = function()
  local handle = io.popen("nb list --no-color --no-indicator --no-id")
  if not handle then
    return
  end

  local results = {}
  for line in handle:lines() do
    table.insert(results, line)
  end
  handle:close()
  Snacks.picker.select({
    items = results,
    prompt = "NB Notes",
    on_choice = function(file)
      if file then
        vim.cmd("edit " .. file)
      end
    end,
  })
end

return M
