return {
	{
		'averms/black-nvim',
		config = function()
			_G.black_enabled = true

			_G.black_sync = function()
				if (_G.black_enabled == true) then
					vim.cmd("call BlackSync()")
				end
			end
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.py",
				command = "lua black_sync()",
			})
		end,
		build = function() vim.cmd("UpdateRemotePlugins") end
	}
}
