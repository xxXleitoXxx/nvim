-- ~/.config/nvim/lua/plugins/git.lua
return {
  -- Gitsigns: Muestra una barrita verde/roja al lado de las líneas que modificas/eliminas
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
      
      -- Atajo rápido para ver ramas de git usando Telescope
      vim.keymap.set("n", "<leader>gb", ":Telescope git_branches<CR>", { desc = "Cambiar de rama (Git Branches)" })
    end
  }
}
