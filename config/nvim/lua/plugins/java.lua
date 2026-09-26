-- ~/.config/nvim/lua/plugins/java.lua
-- Integración avanzada de Java y Spring Boot con Eclipse JDTLS

return {
  "mfussenegger/nvim-jdtls",
  ft = { "java" },
  dependencies = {
    "williamboman/mason.nvim",
    "hrsh7th/cmp-nvim-lsp",
  },
}
