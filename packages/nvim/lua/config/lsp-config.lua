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

-- NOTE: scope :lsp commands to a named client (e.g. `:lsp restart gopls`).
-- A bare `:lsp restart` / `:lsp enable` reaches into nvim-lspconfig's entire
-- bundled registry and starts servers you never configured (gitlab_ls, etc.).
-- Never start rust_analyzer this way either — rustaceanvim owns it (see plugs/rust.lua).
local common_setup = {
	on_attach = on_attach,
	capabilities = require("blink.cmp").get_lsp_capabilities(),
}

local lsps = {
	"gopls",
	"rnix",
	"svelte",
	"clangd",
	"html",
	"cssls",
	"zls",
	"ts_ls",
	sourcekit = {
		filetypes = {
			"swift",
			"objc",
			"objcpp",
			-- "c", "cpp"
			-- let ccls handle c/c++
		},
	},
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

-- Explicitly disable nvim-lspconfig's bundled GitLab Duo server so it can never
-- start by accident (e.g. a bare `:lsp enable`, which enables every discovered
-- config in the runtime's lsp/ dir). Its filetypes include rust/lua/go/etc.
vim.lsp.enable("gitlab_duo", false)

-- Apply project-local VS Code settings (.vscode/settings.json etc.) to every LSP.
-- Workspace-file values override the defaults set below (deep-merge, lists appended).
-- NOTE: rust-analyzer is handled separately in plugs/rust.lua (rustaceanvim doesn't
-- fire this `*` hook for it).
vim.lsp.config("*", {
	before_init = function(_, config)
		require("codesettings").with_local_settings(config.name, config)
	end,
})

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
