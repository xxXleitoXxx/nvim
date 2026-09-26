-- ~/.config/nvim/lua/plugins/indent.lua
-- Guías visuales de indentación limpias y sutiles

return {
  "lukas-reineke/indent-blankline.nvim",
  main = "ibl",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    indent = {
      char = "│",
      tab_char = "│",
    },
    scope = {
      enabled = true,
      show_start = true,
      show_end = false,
    },
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "nvim-tree",
        "Trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
      },
    },
  },
}
