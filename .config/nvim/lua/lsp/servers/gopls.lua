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
            experimentalWatchedFileDelay = "100ms",
            symbolMatcher = "fuzzy",
            gofumpt = true,
            buildFlags = { "-tags", "integration" },
        },
    }
}
