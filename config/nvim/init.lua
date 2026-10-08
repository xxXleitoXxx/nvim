-- Requiere Neovim 0.9+ (vim.keymap, lazy.nvim, LSP moderno).
-- Si ves este mensaje, actualiza Neovim en esa máquina, no es error de la config.
if vim.fn.has("nvim-0.9") == 0 then
  local ver = vim.api.nvim_exec2("version", { output = true }).output:match("NVIM v[%d%.]+") or "versión desconocida"
  vim.api.nvim_err_writeln("Esta config requiere Neovim 0.9+ (detectado: " .. ver .. "). Actualiza Neovim y reintenta.")
  return
end

-- ~/.config/nvim/init.lua

-- 1. Tecla líder (Espacio) - Debe configurarse antes de cargar plugins
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- 2. Cargar opciones base del sistema (indentación, portapapeles Linux, visualización)
require("config.compat")
require("config.options")

-- 3. Cargar atajos de teclado ergonómicos
require("config.keymaps")
require("config.autocmds")

-- 4. Instalar lazy.nvim automáticamente si no está presente
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local uv = vim.uv or vim.loop
if not uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 5. Cargar plugins declarados en lua/plugins/
require("lazy").setup("plugins", {
  defaults = {
    lazy = false,
  },
  checker = {
    enabled = false, -- No molestar con chequeos automáticos constantes en segundo plano
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
