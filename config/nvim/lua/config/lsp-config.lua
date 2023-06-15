local on_attach = require("config.lsp-keybindings").on_attach;
local root_pattern = require("lspconfig.util").root_pattern;


local merge = function(a, b)
	local c = {}
	for k, v in pairs(a) do c[k] = v end
	for k, v in pairs(b) do c[k] = v end
	return c
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
	dynamicRegistration = false,
	lineFoldingOnly = true
}

local common_setup = {
	on_attach = on_attach,
	capabilities = capabilities,
	-- handlers = handlers,
	flags = {
		debounce_text_changes = 150,
	},
}

local lsps = {
	"dhall_lsp_server",
	"gopls",
	-- "jedi_language_server",
	"pyright",
	"rnix",
	"svelte",
	"volar",
	"ccls",
	"tailwindcss",
	denols = {
		root_dir = root_pattern("deno.json", "deno.jsonc")
	},
	hls = {
		-- cmd = { "haskell-language-server", "--lsp" },
		settings = {
			haskell = { formattingProvider = "fourmolu" },
		},
	},
	jsonls = { cmd = { "vscode-json-languageserver", "--stdio" }, },
	lua_ls = {
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
					-- Setup your lua path
					-- path = runtime_path,
					path = vim.split(package.path, ";"),
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim", "awesome", "client", "root", "screen" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					-- library = vim.api.nvim_get_runtime_file("", true),
					library = {
						[vim.fn.expand("$VIMRUNTIME/lua")] = true,
						[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
						["/usr/share/awesome/lib"] = true,
					},
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
				commands = {},
			},
		},
	},
	tsserver = {
		single_file_support = false,
		root_dir = root_pattern('package.json', 'tsconfig.json'),
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
