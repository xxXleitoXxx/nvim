-- ~/.config/nvim/lua/plugins/alpha.lua
return {
  "goolord/alpha-nvim",
  -- Usamos los iconos que ya instalamos previamente
  dependencies = { "nvim-tree/nvim-web-devicons" },
  
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- 1. Aquí configuras tu logo usando Arte ASCII
    -- Puedes ir a generadores online como "patorjk.com/software/taag/" para crear el tuyo
    dashboard.section.header.val = {


"   ▄▄              ▄▄  ▄▄▄                            ",     
  "▐█▌▌            ░█▓░ ▐█▌▌                                ",
 "▐▓█    ▄▄ ▀▄▄▄  ▄▄▀▄ ▐▓█▀▀ ▄▄▄█▀▄▄▄    ▄▄  ▄▄▄   ▄▄  ▄▄▄ ",
"▐▒▒▌  ▐▄█▌▌ ▐▓░▌ ▐ ▄▌▐▒▒▌  ▐▓█▌▌ ▐▓░▌ ▐▄█▌▌ ▐▓░▌▐▄█▌▌ ▐▓░▌",
"█░░   █▓▓  ▄ ▀▀   ▓▌ █░░   █▒▓█  ▐░▓█  ▀░  ▄▄█▀  ▀░  ▄▄█▀ ",
"█░▌▐▄ ▀░▒█▀   ▄ ▐░▒▌ █░▌   ▀█░█  ▐▒▓░▌  ▄▀▀░▒▄    ▄▀▀░▒▄  ",
"▐█▌██▌ ▀░ ▄ ▄██▌██░▄ ██▌██▌ ▀██▄▄░▒ ▀ ▄██▌▀ ░ █▄▄██▌▀ ░ █▄",
" ▀▀█▀     ▀▀▀▀▀       ▀▀▀      ▀▀▀▀   ▀▀▀    ▀▀ ▀▀▀    ▀▀ ",
    }

    -- 2. Estos son los botones o atajos del menú principal
    dashboard.section.buttons.val = {
      dashboard.button("n", "  Nuevo Archivo", "<cmd>ene <BAR> startinsert <CR>"),
      -- Vinculamos la letra 'e' para que abra nuestro NvimTree
      dashboard.button("e", "󰙅  Explorador de Archivos", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("q", "󰅙  Salir de Neovim", "<cmd>qa<CR>"),
    }

    -- Enviamos la configuración al plugin
    alpha.setup(dashboard.opts)
  end,
}
