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

