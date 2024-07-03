-- Format using null-ls for languages that have null-ls configured.
-- Else use the LSP.
-- This lets me override LSP formatting for specific cases, like prettier for JS/TS.
local my_format = function()
	local client = nil;
	for _, value in ipairs(vim.lsp.get_clients()) do
		if (value["name"] == "null-ls") then
			client = value
			break;
		end
	end

	if (client == nil) then
		for _, value in ipairs(vim.lsp.get_clients()) do
			if (value.supports_method("textDocument/formatting")) then
				client = value;
				break;
			end
		end
	end

	if (client ~= nil) then
		vim.lsp.buf.format({
			id = client.id,
			timeout = 5000,
			async = false
		})
	end
end

_G.my_format = my_format

vim.cmd("nnoremap <silent><buffer> <Leader>ff :lua my_format()<CR>")
vim.cmd("autocmd BufWritePre <buffer> lua my_format()")
