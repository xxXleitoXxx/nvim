-- ~/.config/nvim/lua/plugins/ai.lua
return {
  -- Codeium es una de las mejores alternativas gratuitas a GitHub Copilot
  "Exafunction/codeium.vim",
  event = "BufEnter",
  config = function()
    -- Atajos de teclado para el autocompletado
    -- Aceptar la sugerencia con Tab
    vim.keymap.set("i", "<Tab>", function() return vim.fn["codeium#Accept"]() end, { expr = true, silent = true })
    -- Siguiente sugerencia con Alt + ]
    vim.keymap.set("i", "<M-]>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true, silent = true })
    -- Sugerencia anterior con Alt + [
    vim.keymap.set("i", "<M-[>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true, silent = true })
    -- Limpiar la sugerencia con Alt + x
    vim.keymap.set("i", "<M-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true, silent = true })
  end
}
