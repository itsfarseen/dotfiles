vim.wo.foldmethod = 'expr'
vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.wo.foldtext = ''
vim.cmd([[set fillchars=fold:\ ]])
vim.opt.foldlevelstart = 99;
vim.opt.foldnestmax = 1
