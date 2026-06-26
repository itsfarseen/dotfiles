local prettierOrPrettierD = { "prettierd", "prettier", stop_after_first = true }
return {
	"stevearc/conform.nvim",
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			templ = { "templ" },
			go = { "goimports", "gofmt" },
			rust = { "rustfmt" },
			html = prettierOrPrettierD,
			javascriptreact = prettierOrPrettierD,
			typescriptreact = prettierOrPrettierD,
			css = prettierOrPrettierD,
			javascript = prettierOrPrettierD,
			typescript = prettierOrPrettierD,
			json = prettierOrPrettierD,
			yaml = prettierOrPrettierD,
		},
		-- Set default options
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- Set up format-on-save
		format_on_save = { timeout_ms = 2000 },
		-- Customize formatters
		formatters = {
			shfmt = {
				prepend_args = { "-i", "2" },
			},
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local ok, conform = pcall(require, "conform")
				if not ok then
					return
				end
				if #conform.list_formatters_to_run(args.buf) > 0 then
					vim.bo[args.buf].formatexpr = "v:lua.require'conform'.formatexpr()"
				end
			end,
		})
	end,
}
