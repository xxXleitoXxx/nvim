-- Compatibilidad con plugins que aún usan APIs deprecadas.
-- Se carga antes que lazy.nvim para que los plugins silenciosos no ensucien el arranque.

-- Neovim 0.12 deprecó vim.lsp.buf_get_clients() en favor de vim.lsp.get_clients().
-- Plugins como project.nvim y telescope siguen llamando a la versión vieja, así que
-- cada arranque imprime un aviso. Este shim los redirige a la API actual sin ruido.
if vim.fn.has("nvim-0.12") == 1 and vim.lsp.get_clients then
  vim.lsp.buf_get_clients = function(opts)
    opts = opts or {}
    local bufnr = opts.bufnr
    if bufnr == nil or bufnr == 0 then
      bufnr = vim.api.nvim_get_current_buf()
    end
    return vim.lsp.get_clients({ bufnr = bufnr, method = opts.method })
  end
end