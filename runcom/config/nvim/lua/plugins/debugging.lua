return {
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
            local dap = require("dap")
            local dapui = require("dapui")
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
            -- dap_python.setup()
            --dap_python.setup({
            --    pythonPath = function()
            --        -- get the python from the venv
            --        return vim.fn.exepath("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python3")
            --    end,
            --})
            -- dap_python.setup("~/.virtualenvs/debugpy/bin/python3")
            dap_python.setup("~/.local/share/nvim/mason/packages/debugpy/venv/bin/python3.9")

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
            dap.adapters.python = {
                type = "executable",
                command = "python",
                args = { "-m", "debugpy.adapter" },
            }
            dap.configurations.python = {
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
                        -- BUG: not getting the correct environment path
                        if vim.fn.executable(cwd .. '../venv/bin/python') == 1 then
                            print("found venv")
                            return cwd .. '/venv/bin/python'
                        elseif vim.fn.executable(cwd .. '../.venv/bin/python') == 1 then
                            print("found .venv")
                            return cwd .. '/.venv/bin/python'
                        else
                            print("using system python")
                            return '/usr/bin/python3'
                        end
                    end,
                },
                {
                    type = "python",
                    request = "launch",
                    name = "Launch current file with pytest",
                    module = "pytest",
                    args = { "-s", "${file}" },
                    console = "integratedTerminal",
                    justMyCode = false,
                }
            }
            -- add mappings for debugging
            -- FIXME: vim.keymap.set('n', "<F5>", vim.cmd.Ex require('dap').continue()<CR> )
            vim.keymap.set('n', "<F10>", dap.step_over, {})
            vim.keymap.set('n', "<F11>", dap.step_into, {})
            vim.keymap.set('n', "<F12>", dap.step_out, {})
            vim.keymap.set('n', "<leader>dt", dap.toggle_breakpoint, {})
            vim.keymap.set('n', "<leader>dc", dap.continue, {})
            -- vim.keymap.set('n', "<leader>B",
            --   dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')), {})
            -- vim.keymap.set('n', "<leader>lp", dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')), {})
            vim.keymap.set('n', "<leader>dr", dap.repl.open, {})
            vim.keymap.set('n', "<leader>dl", dap.run_last, {})
            -- vim.keymap.set('n', "<leader>di", dap.ui.variables.hover, {})
        end,
    },
}
