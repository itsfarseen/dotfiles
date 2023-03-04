FormatBuf = function()
    local clients = vim.lsp.buf_get_clients();
    if #clients > 0 then
        vim.lsp.buf.formatting_sync()
    end
end

vim.cmd([[
    augroup FormatAutogroup
    autocmd!
    autocmd BufWritePre,FileWritePre * lua FormatBuf()
    augroup END
]])
