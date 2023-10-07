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

local plugins = {
	{ "folke/neodev.nvim" },
	{ "folke/neoconf.nvim", },
	{ "stevearc/dressing.nvim" },
	-- LSP Config
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("neoconf").setup()
			require("config.lsp-config")
		end,
		after = "neoconf.nvim"
	},
	-- Lua formatter
	"ckipp01/stylua-nvim",
	-- Flutter
	"nvim-lua/plenary.nvim",
	"akinsho/flutter-tools.nvim",
	-- Bufdelete
	{ "famiu/bufdelete.nvim",  config = function() vim.cmd([[ nnoremap <leader>x :Bdelete<CR> ]]) end },
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
	"axvr/zepl.vim",    -- Iron REPL
	{ 'nvim-treesitter/nvim-treesitter-context', config = function() require("treesitter-context").setup() end },
	"github/copilot.vim",
	{
		"ray-x/lsp_signature.nvim", -- get lsp function hints as you type
		event = "VeryLazy",
		opts = {},
		config = function(_, opts) require 'lsp_signature'.setup(opts) end
	}
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
	"black-python",
};

-- iterate through configs

require("config.basic")

local final_plugins = {}

local function use(x) table.insert(final_plugins, x) end

for _, v in ipairs(plugins) do
	use(v);
end
for _, plugin in ipairs(pluginsExt) do
	require("plugins." .. plugin)(use);
end

require("lazy").setup(final_plugins)

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
	"ts=typescript"
}

vim.g.python3_host_prog = "/usr/bin/python3"
