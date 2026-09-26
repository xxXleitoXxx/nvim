-- ~/.config/nvim/lua/plugins/qol.lua
return {
  -- 1. Which-Key: Te muestra un menú emergente con tus atajos de teclado
  -- ¡Ya no necesitas memorizar todo! Si presionas Espacio y esperas un segundo, te dirá qué teclas siguen.
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },

  -- 2. Autopairs: Cierra automáticamente los paréntesis, llaves y comillas
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({
        disable_filetype = { "TelescopePrompt", "vim" },
      })
    end,
  },
}
