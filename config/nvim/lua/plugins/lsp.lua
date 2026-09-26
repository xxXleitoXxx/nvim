-- ~/.config/nvim/lua/plugins/lsp.lua
return {
  -- 1. Mason: El gestor de paquetes para herramientas de lenguaje
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- 2. Puente entre Mason y LSPConfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",     -- TypeScript / JavaScript / React
          "pyright",   -- Python
          "jdtls",     -- Java (solo descarga, NO auto-arranque: lo maneja nvim-jdtls en ftplugin/java.lua)
          "html",      -- HTML
          "cssls",     -- CSS
          "lua_ls",    -- Lua (Neovim configuration)
          "marksman",  -- Markdown
        },
        automatic_installation = true,
        -- Evita que mason-lspconfig arranque jdtls por su cuenta (chocaría con nvim-jdtls y pedía Java 21 del wrapper)
        automatic_enable = { exclude = { "jdtls" } },
      })
    end,
  },

  -- 3. Configuración de los servidores de lenguaje (LSP)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Configurar keymaps contextuales al conectar LSP al buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
        callback = function(ev)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
          end

          -- Navegación estilo IDE (funciona en Java/Spring Boot vía JDTLS + resto de LSP)
          map("n", "gd", vim.lsp.buf.definition, "Ir a la Definición")
          map("n", "gD", vim.lsp.buf.declaration, "Ir a la Declaración")
          map("n", "gi", vim.lsp.buf.implementation, "Ir a Implementaciones")
          map("n", "gt", vim.lsp.buf.type_definition, "Ir a Definición de Tipo")
          map("n", "gr", vim.lsp.buf.references, "Ver Referencias del símbolo")
          -- Ctrl-Click estilo VSCode / IntelliJ (requiere opt.mouse = 'a')
          map("n", "<C-LeftMouse>", "<LeftMouse><cmd>lua vim.lsp.buf.definition()<CR>", "Ctrl+Click: Ir a definición")
          map("n", "<C-RightMouse>", "<LeftMouse><cmd>pop<CR>", "Ctrl+Click der: Volver atrás")
          -- Volver atrás en el historial de saltos (después de gd / Ctrl-Click)
          -- Nota: <C-o> ya es volver atrás por defecto, gb es alias mnemotécnico
          map("n", "gb", "<C-o>", "Volver atrás (go back)")
          map("n", "K", vim.lsp.buf.hover, "Mostrar documentación del código")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Renombrar símbolo en el proyecto")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Acciones de código (Quickfix)")
          map("n", "gl", vim.diagnostic.open_float, "Ver error o advertencia detallada")
          map("n", "[d", vim.diagnostic.goto_prev, "Diagnóstico anterior")
          map("n", "]d", vim.diagnostic.goto_next, "Siguiente diagnóstico")
        end,
      })

      -- Configuración moderna compatible con Neovim 0.11 / 0.12 y versiones anteriores
      if vim.lsp.config then
        vim.lsp.config("*", {
          capabilities = capabilities,
        })
        vim.lsp.config("lua_ls", {
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = {
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        })
        vim.lsp.enable({
          "ts_ls",
          "pyright",
          "html",
          "cssls",
          "lua_ls",
          "marksman",
        })
      else
        local lspconfig = require("lspconfig")
        local servers = { "ts_ls", "pyright", "html", "cssls", "marksman" }
        for _, server in ipairs(servers) do
          lspconfig[server].setup({ capabilities = capabilities })
        end
        lspconfig.lua_ls.setup({
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = { globals = { "vim" } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        })
      end
    end,
  },

  -- 4. El motor de autocompletado visual (nvim-cmp)
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- Sugerencias del servidor LSP
      "hrsh7th/cmp-buffer",   -- Sugerencias de palabras del buffer actual
      "hrsh7th/cmp-path",     -- Autocompletado de rutas de archivos en el sistema
      "L3MON4D3/LuaSnip",     -- Motor de snippets
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets", -- Colección exhaustiva de snippets (Spring Boot, Java, Python, React)
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Cargar snippets estilo VSCode (friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-k>"] = cmp.mapping.select_prev_item(),
          ["<C-j>"] = cmp.mapping.select_next_item(),
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
