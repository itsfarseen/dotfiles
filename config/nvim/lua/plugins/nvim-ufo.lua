return function(use)
	use {
		'kevinhwang91/nvim-ufo',
		dependencies = { 'kevinhwang91/promise-async' },
		config = function()
			vim.o.foldcolumn = '1'
			vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
			vim.o.foldlevelstart = 99
			vim.o.foldenable = true

			vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
			vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
			vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
			vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
			vim.keymap.set('n', 'zK', function()
				local winid = require('ufo').peekFoldedLinesUnderCursor()
				if not winid then
					vim.lsp.buf.hover()
				end
			end)

			-- Make lsp the main provider, indent the fallback
			require('ufo').setup({
				provider_selector = function(bufnr, filetype, buftype)
					return {
						'lsp',
						'indent',
					}
				end
			})
		end,
		after = "nvim-lspconfig",
	}
end
