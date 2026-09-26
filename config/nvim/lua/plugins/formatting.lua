-- ~/.config/nvim/lua/plugins/formatting.lua
-- Motor de formateo moderno, asíncrono y extensible

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "v" },
      desc = "Formatear archivo o selección",
    },
    {
      "<leader>fm",
      function()
        require("conform").format({ async = true, lsp_format = "fallback" })
      end,
      mode = { "n", "v" },
      desc = "Formatear archivo o selección",
    },
  },
  opts = {
    -- Asignación de formateadores según tipo de archivo
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "black", stop_after_first = true },
      javascript = { "prettier", stop_after_first = true },
      typescript = { "prettier", stop_after_first = true },
      javascriptreact = { "prettier", stop_after_first = true },
      typescriptreact = { "prettier", stop_after_first = true },
      html = { "prettier", stop_after_first = true },
      css = { "prettier", stop_after_first = true },
      scss = { "prettier", stop_after_first = true },
      json = { "prettier", stop_after_first = true },
      jsonc = { "prettier", stop_after_first = true },
      yaml = { "prettier", stop_after_first = true },
      markdown = { "prettier", stop_after_first = true },
      sh = { "shfmt" },
      bash = { "shfmt" },
      c = { "clang-format" },
      cpp = { "clang-format" },
    },
    -- Formateo automático al guardar el archivo (:w)
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback", -- Si no hay formateador dedicado, usa el servidor LSP
    },
  },
}
