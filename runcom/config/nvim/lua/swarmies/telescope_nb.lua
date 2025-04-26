local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local previewers = require("telescope.previewers")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local conf = require("telescope.config").values
local telescope = require("telescope")

local M = {}

-- Get the current notebook from the .current file
local function get_current_notebook_path()
    local notebook_path =  vim.fn.expand("~/.nb/") .. vim.fn.trim(vim.fn.readfile(vim.fn.expand("~/.nb/.current"))[1])
    return notebook_path
end

M.nb_open_encrypted = function()
    local notebook_path = get_current_notebook_path()
    if notebook_path == "" then
        print("📁 No active notebook found!")
        return
    end

    -- List encrypted notes
    local handle = io.popen("find " .. vim.fn.shellescape(notebook_path) .. " -type f -name '*.enc'")
    if not handle then
        print("❌ Failed to list encrypted notes!")
        return
    end

    local results = {}
    for line in handle:lines() do
        table.insert(results, line)
    end
    handle:close()

    pickers.new({}, {
        prompt_title = "🔒 Encrypted Notes: " .. notebook_path,
        finder = finders.new_table({
            results = results,
            entry_maker = function(entry)
                return {
                    value = entry,
                    display = entry,
                    ordinal = entry,
                }
            end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
            map("i", "<CR>", function()
                local selection = action_state.get_selected_entry()
                actions.close(prompt_bufnr)

                -- Ask for decryption password (hidden input)
                local password = vim.fn.inputsecret("Enter password to decrypt " .. selection.value .. ": ")

                -- Run decryption synchronously
                local handle = io.popen(string.format("openssl enc -d -aes-256-cbc -md sha256 -in '%s' -pass pass:'%s'", selection.value, password))
                if not handle then
                    print("❌ Failed to decrypt file: " .. selection.value)
                    return
                end

                local decrypted_content = handle:read("*a")
                handle:close()

                if decrypted_content == "" then
                    print("❌ Failed to decrypt file: " .. selection.value)
                    return
                end

                vim.schedule(function()
                    -- Open the encrypted file but set the decrypted content
                    vim.cmd("edit " .. vim.fn.fnameescape(selection.value))

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
                            local encrypt_cmd = string.format("openssl enc -aes-256-cbc -md sha256 -in '%s' -out '%s' -pass pass:'%s'", tmpfile, enc_file, save_password)
                            os.execute(encrypt_cmd)
                            os.remove(tmpfile)

                            print("✅ File encrypted and saved: " .. enc_file)

                            -- Close the buffer after saving
                            vim.api.nvim_buf_delete(buf, { force = true })
                        end,
                    })

                    print("✅ Editing encrypted file: " .. selection.value)
                end)
            end)
            return true
        end,
    }):find()
end

-- Custom function to browse nb notes
M.nb_find_files = function()
    local notebook_path = get_current_notebook_path()

    if notebook_path == "" then
        print("📁 No active notebook found!")
        return
    end

    require("telescope.builtin").find_files({
        prompt_title = "📚 NB Notes: " .. notebook_path,
        cwd = notebook_path, -- Set Telescope to search inside the current notebook
        hidden = true,
        follow = true,
        file_ignore_patterns = { "%.lock$", "%.log$", "%.swp$", "%.DS_Store", "%.git", ".obsidian" },
        -- can you handle the ecrypted files?
    })
end


-- Function to search through contents of your notes
M.nb_live_grep = function()
    local notes_directory = get_current_notebook_path()

    require("telescope.builtin").live_grep({
        prompt_title = "Search Notes Content",  -- Title for the search prompt
        cwd = notes_directory,  -- Set the current working directory to your notes folder
        hidden = true,  -- Include hidden files in the search
        file_ignore_patterns = { "%.lock$", "%.log$", "%.swp$", "%.DS_Store" },  -- Ignore unnecessary files
    })
end


-- Custom function to search for notes in all notebooks
M.nb_notes = function()
    local handle = io.popen("nb list --no-color --no-indicator --no-id")
    if not handle then return end

    local results = {}
    for line in handle:lines() do
        table.insert(results, line)
    end
    handle:close()

    pickers.new({}, {
        prompt_title = "NB Notes",
        finder = finders.new_table {
            results = results
        },
        sorter = conf.generic_sorter({}),
        previewer = previewers.new_termopen_previewer({
            get_command = function(entry)
                return { "nb", "show", "-p", entry.value }
            end,
        }),
        attach_mappings = function(prompt_bufnr, map)
            map("i", "<CR>", function()
                local selection = action_state.get_selected_entry()
                -- if the selection is a directory, open it
                -- do this for all subdirectories except the last one
                if selection.ordinal:sub(-1) == "/" then
                    actions.close(prompt_bufnr)
                    vim.cmd("edit " .. selection.value)
                    return
                end
                actions.close(prompt_bufnr)
                vim.cmd("edit " .. selection.value)
            end)
            return true
        end,
    }):find()
end

return M

