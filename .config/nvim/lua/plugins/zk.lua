return {
    "zk-org/zk-nvim",
    config = function()
        local zk = require("zk")
        zk.setup()
    end,
    keys = {
        { "<leader>zn", function()
            vim.ui.input({ prompt = "Note title: " }, function(title)
                if not title or title == "" then
                    return
                end
                require("zk").new({ title = title })
            end)
        end, { desc = "[Z]ettelkasten [N]ew Note" } },
        { "<leader>zf", function()
            local zk = require("zk")
            zk.pick_notes(nil, nil, function(notes)
                if #notes == 0 then
                    return
                end
                vim.cmd("edit " .. notes[1].absPath)
            end)
        end, { desc = "[Z]ettelkasten [F]ind [N]ote" } },
        { "<leader>zt", function()
            local zk = require("zk")
            zk.pick_tags(nil, nil, function(tags)
                if #tags == 0 then
                    return
                end
                local tag = tags[1].name
                zk.pick_notes({ tags = { tag } }, nil, function(notes)
                    if #notes == 0 then
                        return
                    end
                    vim.cmd("edit " .. notes[1].absPath)
                end)
            end)
        end, { desc = "[Z]ettelkasten [F]ind [T]ag" } },
    }
}
