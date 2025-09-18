-- vim:foldmethod=marker:

-- bootstrap "lazy"
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

-- iterate through configs

require("basic")
require("lazy").setup("plugs")
require("plugs-init")
require("keys")
require("winseperator")
require("fold")

-- To highlight codefences returned from denols
vim.g.markdown_fenced_languages = {
	"ts=typescript",
}

vim.g.python3_host_prog = "/usr/bin/python3"

if vim.g.neovide then
	vim.o.guifont = "iosevka:h16"
	vim.g.neovide_cursor_trail_size = 0
end
