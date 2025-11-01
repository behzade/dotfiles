local M = {}

function M.setup()
    local function resolve_basalt_root()
        local env_root = vim.env.BASALT_ROOT
        if env_root and env_root ~= "" and vim.fn.isdirectory(env_root) == 1 then
            return env_root
        end

        local guesses = {
            vim.fs.joinpath(vim.fn.stdpath("config"), "..", "basalt"),
            vim.fs.joinpath(vim.fn.expand("~"), "Projects", "personal", "basalt"),
        }

        for _, path in ipairs(guesses) do
            local full_path = vim.fn.fnamemodify(path, ":p")
            if vim.fn.isdirectory(full_path) == 1 then
                return full_path
            end
        end

        return nil
    end

    require("modules.basalt").setup({ root = resolve_basalt_root() })
end

return M
