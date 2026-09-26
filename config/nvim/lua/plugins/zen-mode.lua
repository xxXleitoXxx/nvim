return {
  "folke/zen-mode.nvim",
  keys = {
    { "<leader>tz", "<cmd>ZenMode<cr>", desc = "Modo Zen / Lectura (Centrado y con márgenes)" },
  },
  opts = {
    window = {
      backdrop = 0.95, -- Oscurece ligeramente el fondo
      width = 90, -- Ancho del bloque de texto (crea márgenes a los lados)
      options = {
        signcolumn = "no", -- Oculta la columna izquierda para lectura pura
        number = false, -- Oculta números de línea en este modo
        relativenumber = false,
        cursorline = false,
        wrap = true, -- Activa el ajuste de línea dentro del bloque estrecho
        linebreak = true, -- Asegura que las palabras no se corten a la mitad
      },
    },
    plugins = {
      -- Desactiva elementos del UI para máxima concentración
      gitsigns = { enabled = false },
      tmux = { enabled = false },
    },
  },
}
