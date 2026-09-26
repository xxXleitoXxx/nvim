-- ~/.config/nvim/lua/plugins/project.lua
return {
  "ahmedkhalf/project.nvim",
  config = function()
    require("project_nvim").setup({
      -- Detecta automáticamente la raíz del proyecto usando estos archivos/carpetas
      patterns = { ".git", "Makefile", "package.json", "go.mod" },
      -- Ignorar carpetas ocultas o de sistema
      exclude_dirs = { "~/.cargo/*" },
      show_hidden = false,
    })
    
    -- Hacer que Telescope pueda buscar los proyectos recientes
    pcall(require("telescope").load_extension, "projects")
    
    -- Atajo: Espacio + f + p para buscar proyectos recientes
    vim.keymap.set("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Buscar proyectos recientes" })
  end,
}
