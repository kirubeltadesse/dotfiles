return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        "leoluz/nvim-dap-go",
        "mfussenegger/nvim-dap-python",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")

        require("dapui").setup()
        require("dap-go").setup()
        require("dap-python").setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python3 ")

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
        -- FIXME: vim.keymap.set('n', "<F5>", vim.cmd.Ex require('dap').continue()<CR> )
        -- vim.keymap.set('n', "<F10>", dap.step_over, {})
        -- vim.keymap.set('n', "<F11>", dap.step_into, {})
        -- vim.keymap.set('n', "<F12>", dap.step_out, {})
        vim.keymap.set('n', "<leader>dt", dap.toggle_breakpoint, {})
        vim.keymap.set('n', "<leader>dc", dap.continue, {})
       -- vim.keymap.set('n', "<leader>B",
        --   dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')), {})
        -- vim.keymap.set('n', "<leader>lp", dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')), {})
        -- vim.keymap.set('n', "<leader>dr", dap.repl.open, {})
        -- vim.keymap.set('n', "<leader>dl", dap.run_last, {})
        -- vim.keymap.set('n', "<leader>di", dap.ui.variables.hover, {})

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
}
