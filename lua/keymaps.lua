-- Escape insert mode with jj
vim.keymap.set("i", "jj", "<Esc>")


-- better up/down
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

vim.keymap.set("n", "<S-h>", "<cmd>bprev<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- <Tab> completion option
vim.keymap.set('i', '<Tab>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'
  end

  return '<Tab>'
end, { expr = true, desc = 'Completion: Accept completion or new line' })

-- Neovim News
vim.keymap.set("n", "<leader>N", "<cmd>help news<cr>", { desc = "Neovim [N]ews" })

-- Vim pack keymap
vim.keymap.set("n", "<leader>Pl", function()
  vim.pack.update(nil, { offline = true })
end, { desc = "[P]ack [l]ist" })

vim.keymap.set("n", "<leader>Ps", function()
  vim.pack.update(nil, { target = "lockfile" })
end, { desc = "[P]ack [s]ync" })
