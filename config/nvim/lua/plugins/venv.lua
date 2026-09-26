-- ~/.config/nvim/lua/plugins/venv.lua
-- Detección y selección automática/manual de entornos virtuales de Python (.venv)

return {
  "linux-cultist/venv-selector.nvim",
  branch = "regexp",
  dependencies = {
    "neovim/nvim-lspconfig",
    "nvim-telescope/telescope.nvim",
  },
  cmd = { "VenvSelect", "VenvSelectCached" },
  keys = {
    { "<leader>vs", "<cmd>VenvSelect<cr>", desc = "Seleccionar entorno virtual Python (.venv)" },
  },
  opts = {
    settings = {
      options = {
        notify_user_on_venv_activation = true,
      },
    },
  },
}
