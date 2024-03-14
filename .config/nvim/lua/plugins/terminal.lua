local autocmd = vim.api.nvim_create_autocmd
local delete_term_buf = function(event)
    if (vim.fn.len(vim.fn.win_findbuf(event.buf)) > 0) then
        if (event.match ~= "UnceptionEditRequestReceived" and #vim.fn.getbufinfo({ buflisted = 1 })) == 1 then
            vim.cmd("q")
        end
        vim.cmd("silent bdelete! " .. event.buf)
    end
end

return {
    "samjwill/nvim-unception",
    config = function()
        autocmd({ "TermClose" }, {
            pattern = { "*" },
            callback = delete_term_buf
        })

        autocmd({ "User" }, {
            pattern = { "UnceptionEditRequestReceived" },
            callback = delete_term_buf
        })
    end
}
