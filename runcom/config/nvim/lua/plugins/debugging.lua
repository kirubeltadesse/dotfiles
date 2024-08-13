return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        "leoluz/nvim-dap-go",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("dapui").setup()
        require("dap-go").setup()

        dap.listeners.after.event_initialized["dapui_config"] = function()
            dapui.open()
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
            dapui.close()
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
            dapui.close()
        end

        -- add mappings for debugging
        --FIXME: vim.keymap.set('n', "<F5>", vim.cmd.Ex require('dap').continue()<CR> )
        -- vim.keymap.set('n', "<F10>", "<cmd>lua require('dap').step_over()<CR>")
        -- vim.keymap.set('n', "<F11>", "<cmd>lua require('dap').step_into()<CR>")
        -- vim.keymap.set('n', "<F12>", "<cmd>lua require('dap').step_out()<CR>")
        vim.keymap.set('n', "<leader>dt", dap.toggle_breakpoint, {})
        vim.keymap.set('n', "<leader>dc", dap.continue, {})
        -- vim.keymap.set('n', "<leader>B",
        --    "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>")
        -- vim.keymap.set('n', "<leader>lp",
        -- "<cmd>lua require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>")
        -- vim.keymap.set('n', "<leader>dr", "<cmd>lua require('dap').repl.open()<CR>")
        -- vim.keymap.set('n', "<leader>dl", "<cmd>lua require('dap').run_last()<CR>")
        -- vim.keymap.set('n', "<leader>di", "<cmd>lua require('dap.ui.variables').hover()<CR>")

        require("dap").adapters.python = {
            type = "executable",
            command = "python",
            args = { "-m", "debugpy.adapter" },
        }
        require("dap").configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch file",
                program = "${file}",
                pythonPath = function()
                    return vim.fn.exepath("python")
                end,
            },
        }
    end,
    --{
    --    "mfussenegger/nvim-dap-python",
    --    ft = "python",
    --    dependencies = {
    --        "mfussenegger/nvim-dap",
    --        "rcarriga/nvim-dap-ui",
    --    },
    --    config = function()
    --        -- setup python debugger
    --        -- replace the path with the path to your python executable
    --        -- where debugpy is ensure_installed
    --        require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/bin/python ")
    --    end,
    --}
}
