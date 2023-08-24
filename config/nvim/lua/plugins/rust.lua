on_attach = require("config.lsp-keybindings").on_attach;

return function(use)
	use {
		"saecki/crates.nvim",
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function() require("crates").setup() end
	};
	use {
		"simrat39/rust-tools.nvim",
		config = function()
			require("rust-tools").setup({
				tools = {
					autoSetHints = true,
					inlay_hints = { only_current_line = false },
				},
				server = {
					on_attach = function(client, bufnr)
						local bufname = vim.api.nvim_buf_get_name(bufnr)
						local home = vim.env.HOME
						local folders = { ".rustup", ".cargo" }
						for _, folder in ipairs(folders) do
							if bufname:find(home .. "/" .. folder, 1) == 1 or bufname:find("~/" .. folder, 1) == 1 then
								vim.schedule(function()
									vim.lsp.buf_detach_client(bufnr, client.id)
								end)
								break
							end
						end
						on_attach(client, bufnr)
					end,
					settings = {
						["rust-analyzer"] = {
							cargo = {
								-- features = {"test-bpf"},
								-- features = "all",
								features = {},
							},
						},
					},
				},
			})
		end,
		after = "nvim-lspconfig",
	};
end
