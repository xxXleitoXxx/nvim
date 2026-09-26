-- ~/.config/nvim/lua/plugins/telescope.lua
return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Esto mejora el rendimiento de búsqueda drásticamente
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
  },
  keys = {
    -- Si quieres buscar archivos en tu proyecto:
    { "<leader>p", "<cmd>Telescope find_files<CR>", desc = "Buscar archivos (Project)" },
    -- Buscar un texto o palabra en TODO tu proyecto:
    { "<leader>g", "<cmd>Telescope live_grep<CR>", desc = "Buscar texto en todo el proyecto" },
    -- El equivalente a un buscador global con barra espaciadora + /
    { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<CR>", desc = "Buscar texto en el archivo actual" },
    -- Navegación LSP estilo IDE (ideal Java/Spring Boot: clases, métodos, implementaciones)
    { "grr", "<cmd>Telescope lsp_references<CR>", desc = "LSP: Referencias (Telescope)" },
    { "gri", "<cmd>Telescope lsp_implementations<CR>", desc = "LSP: Implementaciones (Telescope)" },
    { "grd", "<cmd>Telescope lsp_definitions<CR>", desc = "LSP: Definiciones (Telescope)" },
    { "grt", "<cmd>Telescope lsp_type_definitions<CR>", desc = "LSP: Definiciones de tipo" },
    { "<leader>ds", "<cmd>Telescope lsp_document_symbols<CR>", desc = "Símbolos del archivo actual" },
    { "<leader>ws", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Símbolos del workspace (clases Spring)" },
    { "<leader>wd", "<cmd>Telescope diagnostics<CR>", desc = "Diagnósticos del proyecto" },
  },
  config = function()
    require("telescope").setup({
      defaults = {
        -- Puedes personalizar la apariencia aquí
        prompt_prefix = "   ",
        selection_caret = "  ",
      }
    })
    -- Cargar la extensión fzf para mayor velocidad
    pcall(require("telescope").load_extension, "fzf")
  end,
}
