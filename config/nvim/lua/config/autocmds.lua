-- ~/.config/nvim/lua/config/autocmds.lua
local autocmd = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- Grupo para conversiones automáticas
local doc_converter = augroup("DocumentConverter", { clear = true })

-- Preparar el buffer al abrir DOCX
autocmd("BufReadPre", {
  group = doc_converter,
  pattern = "*.docx",
  callback = function()
    vim.bo.readonly = true
  end,
})

-- Leer archivos DOCX como Markdown automáticamente
autocmd("BufReadPost", {
  group = doc_converter,
  pattern = "*.docx",
  callback = function(args)
    local path = args.file
    -- Usamos vim.fn.system para evitar el error EPIPE (tubería rota)
    local output = vim.fn.system({"pandoc", "-f", "docx", "-t", "markdown", path})
    local lines = vim.split(output, "\n")
    if lines[#lines] == "" then table.remove(lines) end
    
    vim.bo.readonly = false
    vim.bo.modifiable = true
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    
    vim.bo.filetype = "markdown"
    vim.bo.modified = false
    vim.notify("DOCX convertido a Markdown", vim.log.levels.INFO)
  end,
})

-- Leer archivos PDF como texto automáticamente
autocmd("BufReadPost", {
  group = doc_converter,
  pattern = "*.pdf",
  callback = function(args)
    local path = args.file
    local output = vim.fn.system({"pdftotext", "-layout", path, "-"})
    local lines = vim.split(output, "\n")
    if lines[#lines] == "" then table.remove(lines) end
    
    vim.bo.readonly = false
    vim.bo.modifiable = true
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    
    vim.bo.filetype = "markdown"
    vim.bo.modified = false
    vim.bo.readonly = true
    vim.bo.modifiable = false
    vim.notify("PDF extraído. (Solo lectura)", vim.log.levels.INFO)
  end,
})
