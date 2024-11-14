return {

    {
        "mfussenegger/nvim-jdtls",
        ft = { "java" },
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
            -- Virtual text for the current line
            "theHamsta/nvim-dap-virtual-text",
            "leoluz/nvim-dap-go",
            "mfussenegger/nvim-dap-python",
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")

            dapui.setup()
            local dap_virtual_text = require("nvim-dap-virtual-text")
            local dap_python = require("dap-python")

            dap_virtual_text.setup({
                virtual_text = true,
                underline = true,
                signs = true,
                update_in_insert = true,
            })

            dapui.setup()
            require("dap-go").setup()
            dap_python.setup "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
            dap_python.test_runner = "pytest"

            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end

            dap.set_log_level("TRACE")
            dap.defaults.timeout = 3000 -- 3 seconds
            table.insert(dap.configurations.python, {
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    -- cmd = "/usr/bin/python3",
                    program = "${file}",
                    pythonPath = function()
                        -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                        -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                        -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                        local cwd = vim.fn.getcwd()
                        print("command work directory: ", cwd)
                        if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                            print("found venv")
                            return cwd .. '/venv/bin/python3.12'
                        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                            print("found .venv")
                            return cwd .. '/.venv/bin/python3.12'
                        elseif vim.fn.executable(cwd .. '/.env/bin/python') == 1 then
                            print("found .env")
                            return cwd .. '/.env/bin/python3.12'
                        else
                            print("using system python")
                            return '/usr/bin/python3'
                        end
                    end,
                },
                {
                    type = "python",
                    request = "attach",
                    name = "Attach app",
                    connect = {
                        host = "localhost",
                        port = 9977,
                    },
                    pathMappings = {
                        {
                            localRoot = "${workspaceFolder}",
                            -- localRoot = vim.fn.getcwd(),
                            remoteRoot = ".",
                        },
                    },
                    justMyCode = true,
                },
                {
                    type = "python",
                    request = "launch",
                    name = "Launch current file with pytest",
                    module = "pytest",
                    args = { "-s", "${file}" },
                    console = "integratedTerminal",
                    justMyCode = false,
                },
            })
            -- add mappings for debugging
            vim.keymap.set('n', "<leader>do", dap.step_over, { desc = "Step over" })
            vim.keymap.set('n', "<leader>di", dap.step_into, { desc = "Step into" })
            vim.keymap.set('n', "<leader>dO", dap.step_out, { desc = "Step out" })
            vim.keymap.set('n', "<leader>dt", dap.toggle_breakpoint, { desc = "toggle breakpoint" })
            vim.keymap.set('n', "<leader>dc", dap.continue, { desc = "continue debugging" })
            -- Conditional Breakpoint
            vim.keymap.set('n', '<leader>db', function()
                dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
            end, { desc = 'Set conditional breakpoint' })

            -- Log Point Breakpoint
            vim.keymap.set('n', '<leader>dl', function()
                dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))
            end, { desc = 'Set log point' })

            -- Clear all breakpoints
            vim.keymap.set('n', '<leader>dC', dap.clear_breakpoints, { desc = 'Clear all breakpoints' })
            vim.keymap.set('n', "<leader>dr", dap.repl.open, { desc = "open repl" })
            vim.keymap.set('n', "<leader>dl", dap.run_last, { desc = "run last" })
            vim.keymap.set('n', "<leader>dv", function()
                local widgets = require('dap.ui.widgets')
                widgets.hover()
            end, { desc = "Debug Ui Varaibles" })
        end,
    },
}
