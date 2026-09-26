-- lua/plugins/nvim-tree.lua
-- Explorador de archivos fijo con ancho amplio y optimizado para proyectos anidados

return {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Alternar explorador (NvimTree)" },
    { "<leader>f", "<cmd>NvimTreeFocus<CR>", desc = "Enfocar explorador (NvimTree)" },
  },
  config = function()
    -- Desactivar netrw nativo de Neovim
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    require("nvim-tree").setup({
      -- Mantener sincronizado el explorador con el archivo abierto
      update_focused_file = {
        enable = true,
        update_cwd = true,
      },
      -- Configuración de la ventana (fija, sin deformarse con splits)
      view = {
        width = 38,                         -- Ancho ampliado para que quepan nombres largos de Java/React
        side = "left",
        preserve_window_proportions = true, -- Evita que se encoja o agrande al abrir divisiones/splits
        number = false,
        relativenumber = false,
        signcolumn = "no",                  -- Ahorra espacio visual en el árbol
      },
      renderer = {
        group_empty = true,                 -- Compacta carpetas vacías anidadas (ej. com/camunda/service)
        highlight_git = true,
        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
          },
        },
      },
      actions = {
        open_file = {
          resize_window = false,            -- No redimensionar el árbol al abrir un archivo
          window_picker = {
            enable = true,
          },
        },
      },
    })
  end,
}
