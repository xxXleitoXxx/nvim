-- ~/.config/nvim/lua/plugins/tema.lua
return {
  -- Repositorio del tema en GitHub
  "folke/tokyonight.nvim",
  
  -- lazy = false asegura que el tema se cargue inmediatamente al abrir Neovim
  lazy = false,
  -- priority = 1000 asegura que el tema cargue antes que los demás plugins
  priority = 1000,
  
  -- Función que se ejecuta al cargar el plugin
  config = function()
    -- Aplicamos el tema. Tokyonight tiene variantes: "tokyonight-night", "tokyonight-storm", "tokyonight-day"
    vim.cmd.colorscheme("tokyonight-night")
  end,
}
