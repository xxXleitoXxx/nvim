return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown", "markdown_inline" },
    opts = {
      -- Límite de tamaño del archivo (en MB) para deshabilitar el plugin automáticamente en archivos muy grandes
      max_file_size = 1.5, 
    },
    keys = {
      {
        "<leader>tm", -- Atajo: Toggle Markdown (Activar/Desactivar)
        "<cmd>RenderMarkdown toggle<CR>",
        desc = "Activar/Desactivar Renderizado de Markdown",
      },
    },
  },
}
