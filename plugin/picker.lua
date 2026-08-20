vim.pack.add({ "https://github.com/alexpasmantier/tv.nvim" })

vim.keymap.set("n", "<Leader><Leader>", "<cmd>Tv files<CR>", { desc = "[TV] Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Tv text<CR>", { desc = "[TV] Live grep" })
vim.keymap.set("n", "<leader>fc", function()
  require("tv").tv_channel("text", vim.fn.expand("<cword>"))
end, { desc = "[TV] Search word" })
