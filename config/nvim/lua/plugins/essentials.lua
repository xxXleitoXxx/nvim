-- ~/.config/nvim/lua/plugins/essentials.lua
return {
  -- 1. Barra de estado inferior (Lualine)
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "auto", -- Sincronizado con tokyonight
          globalstatus = true,
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
      })
    end,
  },

  -- 2. Resaltado e indentación estructural avanzada (Treesitter)
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    dependencies = {
      -- Auto-cierre y auto-renombrado inteligente de etiquetas HTML/JSX/TSX
      "windwp/nvim-ts-autotag",
    },
    config = function()
      -- Treesitter compila los parsers con un compilador C. Si el servidor no lo tiene,
      -- pedir ensure_installed lanzaba un error por cada parser; mejor un aviso claro
      -- y se sigue con el resaltado por regex de Neovim.
      local has_compiler = false
      for _, cc in ipairs({ "cc", "gcc", "clang", "zig" }) do
        if vim.fn.executable(cc) == 1 then
          has_compiler = true
          break
        end
      end
      if not has_compiler then
        vim.schedule(function()
          vim.notify(
            "nvim-portable: no hay compilador C, Treesitter no instalará parsers (resaltado reducido). "
              .. "Instala build-essential (apt) o gcc (dnf).",
            vim.log.levels.WARN
          )
        end)
      end

      require("nvim-treesitter.configs").setup({
        ensure_installed = has_compiler
          and {
            "c",
            "cpp",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "javascript",
            "typescript",
            "tsx",
            "python",
            "java",
            "html",
            "css",
            "json",
            "yaml",
            "bash",
            "markdown",
            "markdown_inline",
          }
          or {},
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        -- Indentación estructural asistida por Treesitter (corrige sangría automática)
        indent = {
          enable = true,
        },
        autotag = {
          enable = true,
        },
      })
    end,
  },
}
