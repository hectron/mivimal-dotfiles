vim.pack.add({
  "https://github.com/oskarnurm/koda.nvim",
  {
    src = "https://github.com/rose-pine/neovim",
    name = "rose-pine",
  },
})

require("koda").setup({
  transparent = true,
  theme = { dark = "moss", light = "glade" },
})
vim.cmd.colorscheme([[koda]])
