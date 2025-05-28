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

-- Show documentation (K) {{{
-- vim.api.nvim_set_keymap("n", "K", ":lua ShowDocumentation()<cr>", { noremap = true, silent = true })
-- function ShowDocumentation()
-- local filetype = vim.bo.filetype
-- if vim.tbl_contains({ "vim", "help" }, filetype) then
-- vim.cmd("h " .. vim.fn.expand("<cword>"))
-- elseif vim.tbl_contains({ "man" }, filetype) then
-- vim.cmd("Man " .. vim.fn.expand("<cword>"))
-- elseif vim.fn.expand("%:t") == "Cargo.toml" then
-- require("crates").show_popup()
-- else
-- vim.lsp.buf.hover()
-- end
-- end

-- }}}

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
-- virtual_text = true,
-- underline = true,
-- signs = true,
-- })
-- vim.cmd([[
--   set updatetime=300
-- augroup cursor_hover
-- autocmd!
--   autocmd CursorHold * lua vim.diagnostic.open_float(nil, {border = "single", focusable = false})
--   autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
-- augroup end
-- ]])

-- Key binds

local border = {
	{ "🭽", "FloatBorder" },
	{ "▔", "FloatBorder" },
	{ "🭾", "FloatBorder" },
	{ "▕", "FloatBorder" },
	{ "🭿", "FloatBorder" },
	{ "▁", "FloatBorder" },
	{ "🭼", "FloatBorder" },
	{ "▏", "FloatBorder" },
}

-- LSP settings (for overriding per client)
local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

-- To highlight codefences returned from denols
vim.g.markdown_fenced_languages = {
	"ts=typescript",
}

vim.g.python3_host_prog = "/usr/bin/python3"

if vim.g.neovide then
	vim.o.guifont = "iosevka:h16"
	vim.g.neovide_cursor_trail_size = 0
end
