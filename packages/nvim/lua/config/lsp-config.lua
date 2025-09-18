local on_attach = require("config.lsp-keybindings").on_attach

local merge = function(a, b)
	local c = {}
	for k, v in pairs(a) do
		c[k] = v
	end
	for k, v in pairs(b) do
		c[k] = v
	end
	return c
end

local common_setup = {
	on_attach = on_attach,
}

local lsps = {
	"gopls",
	"rnix",
	"svelte",
	"ccls",
	"html",
	"cssls",
	"zls",
	"ts_ls",
	jsonls = { cmd = { "vscode-json-languageserver", "--stdio" } },
	hls = {
		filetypes = { "haskell", "lhaskell", "cabal" },
		settings = {
			haskell = {
				manageHLS = "GHCup",
				formattingProvider = "ormolu",
				cabalFormattingProvider = "cabal-gild",
			},
		},
	},
	lua_ls = {
		settings = {
			Lua = {
				workspace = {
					preloadFileSize = 100,
				},
				telemetry = {
					enable = false,
				},
			},
		},
	},
	purescriptls = {
		settings = {
			purescript = {
				formatter = "purs-tidy",
			},
		},
	},
	pyright = {
		settings = {
			python = {
				analysis = {
					autoSearchPaths = true,
					useLibraryCodeForTypes = true,
					diagnosticMode = "openFilesOnly",
					stubPath = vim.fn.stdpath("data") .. "/lazy/python-type-stubs",
				},
			},
		},
	},
}

for k, v in pairs(lsps) do
	local lsp_name, setup_table
	if type(v) == "string" then
		lsp_name = v
		setup_table = common_setup
	else
		lsp_name = k
		setup_table = merge(common_setup, v)
	end
	vim.lsp.config(lsp_name, setup_table)
	vim.lsp.enable(lsp_name)
end
