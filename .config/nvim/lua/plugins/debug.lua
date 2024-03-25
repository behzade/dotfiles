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
        'theHamsta/nvim-dap-virtual-text',
        config = function()
            require("nvim-dap-virtual-text").setup()
        end
    }
}
