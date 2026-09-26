-- ~/.config/nvim/lua/plugins/persistence.lua
return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- Solo se carga cuando abres archivos reales
  opts = { options = { "buffers", "curdir", "tabpages", "winsize" } },
  -- Atajos de teclado para restaurar tus proyectos
  keys = {
    { "<leader>sr", function() require("persistence").load() end, desc = "Restaurar sesión/proyecto actual" },
    { "<leader>sl", function() require("persistence").load({ last = true }) end, desc = "Restaurar último proyecto" },
    { "<leader>sd", function() require("persistence").stop() end, desc = "No guardar la sesión al salir" },
  },
}
