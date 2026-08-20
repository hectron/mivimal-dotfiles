vim.pack.add({
  "https://github.com/barrettruth/canola.nvim",
})

require("oil").setup()

vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "[Canola] Open parent dir" })
