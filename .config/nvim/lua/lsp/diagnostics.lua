local diagnostic = vim.diagnostic
Diagnostics = {}
Diagnostics.next = function()
	diagnostic.goto_next({ float = { border = "single" } })
end
Diagnostics.prev = function()
	diagnostic.goto_prev({ float = { border = "single" } })
end
return Diagnostics
