vim.pack.add({
  "https://github.com/oskarnurm/koda.nvim",
  {
    src = "https://github.com/rose-pine/neovim",
    name = "rose-pine",
  },
})

require("rose-pine").setup({
  styles = {
    transparency = true,
  }
})

require("koda").setup({
  transparent = true,
  theme = { dark = "moss", light = "light" },
})

if vim.o.background == "dark" then
  vim.cmd.colorscheme([[rose-pine]])
else
  vim.cmd.colorscheme([[koda]])
end
