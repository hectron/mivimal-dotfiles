vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

require("fzf-lua").setup()

vim.keymap.set("n", "<Leader><Leader>", function ()
  require("fzf-lua").files({ resume = true })
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>be", function ()
  require("fzf-lua").buffers()
end, { desc = "Buffer explorer" })

vim.keymap.set("n", "<leader>fg", function ()
  require("fzf-lua").live_grep_native()
end, { desc = "Live grep" })

vim.keymap.set("n", "<leader>fh", function ()
  require("fzf-lua").helptags()
end, { desc = "Help tags" })

vim.keymap.set("n", "<leader>fc", function()
  require("fzf-lua").grep_cword()
end, { desc = "Search word" })
