local wezterm = require("wezterm")

local config = {
    bidi_enabled = true,
    font = wezterm.font_with_fallback({
        "JetBrains Mono NerdFont",
        { family = "Vazir Code Hack" },
    }),
    font_size = 14,
    color_scheme = "GruvboxDarkHard",
    cursor_blink_ease_in = "Constant",
    cursor_blink_ease_out = "Constant",
}

return config
