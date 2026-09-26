-- ~/.config/nvim/lua/plugins/surround.lua
-- Manipulación rápida de delimitadores (comillas, paréntesis, etiquetas HTML/JSX)

return {
  "kylechui/nvim-surround",
  version = "*",
  event = "VeryLazy",
  config = function()
    require("nvim-surround").setup({})
  end,
}
