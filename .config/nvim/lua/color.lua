local mode = io.popen("darkman get"):read("*l")
if mode == "dark" then
   vim.opt.background = mode
   vim.cmd([[colorscheme github_dark]])
else
   vim.opt.background = "light"
   vim.cmd([[colorscheme github_light]])
end

