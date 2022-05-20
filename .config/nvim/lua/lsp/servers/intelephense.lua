local home = os.getenv("HOME")

return {
    root_dir = function() return home .. "/Projects/supernova-env-dev/vendor" end,
    opts = {}
}
