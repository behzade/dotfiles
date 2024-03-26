return {
    {
        "mfussenegger/nvim-dap",
        config = function()
            local dap = require("dap")
            dap.adapters.delve = {
                port = "2345",
                type = "server"
            }
            dap.configurations.go = {
                {
                    type = 'delve',
                    mode = "remote",
                    name = 'Attach remote',
                    request = 'attach',
                    showLog = true,
                    substitutePath = {
                        {
                            from = '${workspaceFolder}',
                            to = '/app'
                        },
                    },
                },
            }
        end
    },
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
        config = function()
            local dap, dapui = require("dap"), require("dapui")
            dapui.setup()
            dap.listeners.before.attach.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                dapui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                dapui.close()
            end
        end
    },
}
