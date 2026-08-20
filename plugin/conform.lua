vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
})

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
  },
})

vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
