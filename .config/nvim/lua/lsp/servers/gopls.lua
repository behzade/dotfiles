return {
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                unreachable = true,
                shadow = true,
                fieldalignment = true,
                nilness = true,
                unusedwrite = true,
            },
            codelenses = {
                gc_details = true,
            },
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            matcher = "fuzzy",
            symbolMatcher = "fuzzy",
            -- gofumpt = true,
            buildFlags = { "-tags", "integration" },
        },
    }
}
