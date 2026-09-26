-- ~/.config/nvim/lua/config/keymaps.lua
-- Atajos de teclado ergonómicos para desarrollo

local map = vim.keymap.set

-- 1. Guardar y salir rápidamente
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Guardar archivo actual" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Cerrar ventana actual" })

-- 2. Limpiar el resaltado de búsqueda
map("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Limpiar resaltado de búsqueda" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpiar resaltado de búsqueda con Escape" })

-- 3. Mover bloques de código seleccionados arriba/abajo en modo Visual (respetando indentación)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Mover bloque seleccionado hacia abajo" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Mover bloque seleccionado hacia arriba" })

-- 4. Mantener el cursor centrado en la pantalla al desplazarse
map("n", "<C-d>", "<C-d>zz", { desc = "Bajar media página centrado" })
map("n", "<C-u>", "<C-u>zz", { desc = "Subir media página centrado" })
map("n", "n", "nzzzv", { desc = "Siguiente resultado de búsqueda centrado" })
map("n", "N", "Nzzzv", { desc = "Resultado de búsqueda anterior centrado" })

-- 5. Navegación fluida entre divisiones de ventanas (Splits)
map("n", "<C-h>", "<C-w>h", { desc = "Ir a la ventana izquierda" })
map("n", "<C-j>", "<C-w>j", { desc = "Ir a la ventana inferior" })
map("n", "<C-k>", "<C-w>k", { desc = "Ir a la ventana superior" })
map("n", "<C-l>", "<C-w>l", { desc = "Ir a la ventana derecha" })

-- 6. Gestión rápida de Buffers (archivos abiertos)
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Buffer anterior" })
map("n", "]b", "<cmd>bnext<CR>", { desc = "Buffer siguiente" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Cerrar buffer actual" })

-- 7. Atajo de formateo rápido (integrado con conform / LSP)
map({ "n", "v" }, "<leader>cf", function()
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format({ async = true, lsp_format = "fallback" })
  else
    vim.lsp.buf.format({ async = true })
  end
end, { desc = "Formatear archivo o selección" })

map({ "n", "v" }, "<leader>fm", function()
  local ok, conform = pcall(require, "conform")
  if ok then
    conform.format({ async = true, lsp_format = "fallback" })
  else
    vim.lsp.buf.format({ async = true })
  end
end, { desc = "Formatear archivo o selección" })

-- 8. Navegación estilo IDE (fallback global, funciona aun sin LSP activo)
-- En terminales sin soporte de mouse, usa gd / gi. Con mouse, Ctrl+Click.
-- <C-LeftMouse> real se define por buffer en LspAttach + ftplugin/java.lua;
-- aquí dejamos un fallback global a ctags/definición LSP.
map("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Ctrl+Click: Ir a definición" })
map("n", "gb", "<C-o>", { desc = "Volver atrás tras salto (go back)" })

-- 9. Opciones de visualización
map("n", "<leader>tw", function()
  vim.wo.wrap = not vim.wo.wrap
end, { desc = "Activar/Desactivar ajuste de línea (Wrap)" })

-- Moverse por líneas visuales (útil cuando wrap está activado)
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Abajo (línea visual)", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Arriba (línea visual)", expr = true, silent = true })

-- 10. Suite de Conversión de Documentos (MD, DOCX, PDF)

-- 10. Suite de Conversión de Documentos (MD, DOCX, PDF)

-- Exportar a Word (.docx)
map("n", "<leader>cw", function()
  local filepath = vim.fn.expand("%:p")
  if filepath == "" then vim.notify("Guarda el archivo primero", vim.log.levels.ERROR) return end
  local ext = vim.fn.expand("%:e"):lower()
  local outpath = vim.fn.expand("%:p:r") .. ".docx"
  
  if ext == "pdf" then
    vim.notify("Convirtiendo PDF a Word (vía LibreOffice)...", vim.log.levels.INFO)
    vim.fn.system(string.format("libreoffice --headless --infilter='writer_pdf_import' --convert-to docx %s --outdir %s", vim.fn.shellescape(filepath), vim.fn.shellescape(vim.fn.expand("%:p:h"))))
    if vim.v.shell_error == 0 then vim.notify("¡Word generado! " .. outpath, vim.log.levels.INFO) end
  elseif ext == "md" or vim.bo.filetype == "markdown" then
    vim.notify("Convirtiendo Markdown a Word...", vim.log.levels.INFO)
    vim.fn.system(string.format("pandoc %s -o %s", vim.fn.shellescape(filepath), vim.fn.shellescape(outpath)))
    if vim.v.shell_error == 0 then vim.notify("¡Word generado! " .. outpath, vim.log.levels.INFO) end
  else
    vim.notify("Usa este comando en archivos .md o previsualizaciones .pdf", vim.log.levels.WARN)
  end
end, { desc = "Convertir a Word (.docx)" })

-- Exportar a PDF (.pdf)
map("n", "<leader>cp", function()
  local filepath = vim.fn.expand("%:p")
  if filepath == "" then vim.notify("Guarda el archivo primero", vim.log.levels.ERROR) return end
  local ext = vim.fn.expand("%:e"):lower()
  local outpath = vim.fn.expand("%:p:r") .. ".pdf"
  local outdir = vim.fn.expand("%:p:h")
  
  if ext == "docx" then
    vim.notify("Convirtiendo Word a PDF (vía LibreOffice)...", vim.log.levels.INFO)
    vim.fn.system(string.format("libreoffice --headless --convert-to pdf %s --outdir %s", vim.fn.shellescape(filepath), vim.fn.shellescape(outdir)))
    if vim.v.shell_error == 0 then vim.notify("¡PDF generado! " .. outpath, vim.log.levels.INFO) end
  elseif ext == "md" or vim.bo.filetype == "markdown" then
    vim.notify("Generando PDF desde Markdown (paso doble)...", vim.log.levels.INFO)
    local tmp_docx = vim.fn.expand("%:p:r") .. "_tmp.docx"
    vim.fn.system(string.format("pandoc %s -o %s", vim.fn.shellescape(filepath), vim.fn.shellescape(tmp_docx)))
    vim.fn.system(string.format("libreoffice --headless --convert-to pdf %s --outdir %s", vim.fn.shellescape(tmp_docx), vim.fn.shellescape(outdir)))
    vim.fn.delete(tmp_docx) -- Limpiar archivo temporal
    vim.notify("¡PDF generado! " .. outpath, vim.log.levels.INFO)
  else
    vim.notify("Usa este comando en archivos .md o previsualizaciones .docx", vim.log.levels.WARN)
  end
end, { desc = "Convertir a PDF (.pdf)" })

-- Guardar interceptado a Markdown (.md)
map("n", "<leader>cm", function()
  local ext = vim.fn.expand("%:e"):lower()
  if ext ~= "pdf" and ext ~= "docx" then
    vim.notify("Este atajo es para guardar PDFs o Words que estás previsualizando", vim.log.levels.WARN)
    return
  end
  local outpath = vim.fn.expand("%:p:r") .. "-md.md"
  
  -- Guardamos evitando que los formateadores automáticos (conform.nvim) fallen
  vim.cmd("noautocmd silent write " .. vim.fn.fnameescape(outpath))
  vim.cmd("edit " .. vim.fn.fnameescape(outpath))
  
  vim.notify("Guardado y editando: " .. vim.fn.fnamemodify(outpath, ":t"), vim.log.levels.INFO)
end, { desc = "Guardar PDF/Word como Markdown (-md.md)" })
