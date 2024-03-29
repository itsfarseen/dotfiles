local on_attach = require("config.lsp-keybindings").on_attach
local root_pattern = require("lspconfig.util").root_pattern

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

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true,
}
capabilities.textDocument.completion.completionItem.snippetSupport = true

local common_setup = {
	on_attach = on_attach,
	capabilities = capabilities,
	-- handlers = handlers,
	flags = {
		debounce_text_changes = 150,
	},
}

local lsps = {
	"denols",
	"dhall_lsp_server",
	"gopls",
	"pyright",
	"rnix",
	"svelte",
	"tsserver",
	"volar",
	"ccls",
	"tailwindcss",
	"html",
	"cssls",
	denols = {
		root_dir = root_pattern("deno.json", "deno.jsonc"),
	},
	hls = {
		settings = {
			haskell = { formattingProvider = "fourmolu" },
		},
	},
	jsonls = { cmd = { "vscode-json-languageserver", "--stdio" } },
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
	tsserver = {
		single_file_support = false,
		root_dir = root_pattern("package.json", "tsconfig.json"),
	},
}

local nvim_lsp = require("lspconfig")
for k, v in pairs(lsps) do
	if type(v) == "string" then
		nvim_lsp[v].setup(common_setup)
	else
		nvim_lsp[k].setup(merge(common_setup, v))
	end
end
