-- vim:foldmethod=marker:

local plugins = {
	'wbthomason/packer.nvim',
	-- Colorscheme
	"stevearc/dressing.nvim",
	-- LSP Config
	"neovim/nvim-lspconfig",
	-- Lua formatter
	"ckipp01/stylua-nvim",
	-- Flutter
	"nvim-lua/plenary.nvim",
	"akinsho/flutter-tools.nvim",
	-- Bufdelete
	{ "famiu/bufdelete.nvim", config = function() vim.cmd([[ nnoremap <leader>x :Bdelete<CR> ]]) end },
	-- Surround
	{
		"ur4ltz/surround.nvim",
		config = function() require("surround").setup({ mappings_style = "sandwich", space_on_closing_char = true }) end,
	},
	-- Registers
	{
		"tversteeg/registers.nvim",
		config = function()
			local registers = require("registers")
			registers.setup({
				show_empty = false,
			})
		end,
	},
	{ "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
	"tpope/vim-abolish", -- Find/Replace variants of a word
	"axvr/zepl.vim", -- Iron REPL
	{ 'nvim-treesitter/nvim-treesitter-context', config = function() require("treesitter-context").setup() end },
	"github/copilot.vim",
};

local pluginsExt = {
	"lualine",
	"rust",
	"colorscheme",
	"telescope",
	"filetypes",
	"nvim-tree",
	"gitsigns",
	"treesitter",
	"nvim-ufo",
	"cmp",
	"prettier",
};

-- iterate through configs

local configs = {
	"basic",
	-- "autoformat", -- commented in favor of lsp-keybindings.lua
	"lsp-config",
};

local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
		vim.cmd [[packadd packer.nvim]]
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer()

require("packer").startup(function(use)
	for _, v in ipairs(plugins) do
		use(v);
	end
	for _, plugin in ipairs(pluginsExt) do
		require("plugins." .. plugin)(use);
	end
	if packer_bootstrap then
		require('packer').sync()
	end
end);

for _, v in ipairs(configs) do
	require("config." .. v)
end

-- Show documentation (K) {{{
-- vim.api.nvim_set_keymap("n", "K", ":lua ShowDocumentation()<cr>", { noremap = true, silent = true })
-- function ShowDocumentation()
-- 	local filetype = vim.bo.filetype
-- 	if vim.tbl_contains({ "vim", "help" }, filetype) then
-- 		vim.cmd("h " .. vim.fn.expand("<cword>"))
-- 	elseif vim.tbl_contains({ "man" }, filetype) then
-- 		vim.cmd("Man " .. vim.fn.expand("<cword>"))
-- 	elseif vim.fn.expand("%:t") == "Cargo.toml" then
-- 		require("crates").show_popup()
-- 	else
-- 		vim.lsp.buf.hover()
-- 	end
-- end

-- }}}

-- vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
-- 	virtual_text = true,
-- 	underline = true,
-- 	signs = true,
-- })
-- vim.cmd([[
--   set updatetime=300
-- 	augroup cursor_hover
-- 	autocmd!
--   autocmd CursorHold * lua vim.diagnostic.open_float(nil, {border = "single", focusable = false})
--   autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
-- 	augroup end
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
	"ts=typescript"
}
