return function(use)
	use {
			"nvim-telescope/telescope.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				vim.cmd([[
					nnoremap <c-p> <cmd>Telescope find_files<cr>
					nnoremap <leader>ff <cmd>Telescope find_files<cr>
					nnoremap <leader>fgg <cmd>Telescope live_grep<cr>
					nnoremap <leader>fb <cmd>Telescope buffers<cr>
					nnoremap <leader>fh <cmd>Telescope help_tags<cr>
					nnoremap <leader>fm <cmd>Telescope marks<cr>
					nnoremap <leader>fr <cmd>Telescope lsp_references<cr>
					nnoremap <leader>fs <cmd>Telescope lsp_document_symbols<cr>
					nnoremap <leader>fS <cmd>Telescope lsp_workspace_symbols<cr>
					nnoremap <leader>fa <cmd>lua vim.lsp.buf.code_action()<cr>
					vnoremap <leader>fa <cmd>lua vim.lsp.buf.code_action({range=nil})<cr>
					nnoremap <leader>fe <cmd>Telescope diagnostics<cr>
					nnoremap <leader>fd <cmd>Telescope lsp_definitions<cr>
					nnoremap <leader>fD <cmd>Telescope lsp_type_definitions<cr>
					nnoremap <leader>fi <cmd>Telescope lsp_implementations<cr>
					nnoremap <leader>fgs <cmd>Telescope git_status<cr>
					nnoremap <leader>ft <cmd>Telescope treesitter<cr>
				]])
			end
	};
end
