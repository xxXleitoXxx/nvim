-- ~/.config/nvim/lua/plugins/bufferline.lua
-- Pestañas superiores visuales para gestionar buffers abiertos

return {
  "akinsho/bufferline.nvim",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  keys = {
    { "<Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Siguiente pestaña/buffer" },
    { "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Pestaña/buffer anterior" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Fijar/Desfijar buffer" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Cerrar los demás buffers" },
  },
  opts = {
    options = {
      mode = "buffers",
      diagnostics = "nvim_lsp", -- Muestra indicadores de errores/advertencias en cada pestaña
      diagnostics_indicator = function(count, level)
        local icon = level:match("error") and " " or " "
        return " " .. icon .. count
      end,
      always_show_bufferline = true,
      show_buffer_close_icons = true,
      show_close_icon = false,
      color_icons = true,
      separator_style = "slant",
      offsets = {
        {
          filetype = "NvimTree",
          text = "Explorador de Archivos",
          highlight = "Directory",
          text_align = "left",
          separator = true,
        },
      },
    },
  },
}
