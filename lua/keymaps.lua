-- Escape insert mode with jj
vim.keymap.set("i", "jj", "<Esc>")

vim.keymap.set('n', '<leader>Pl', function()
  vim.pack.update(nil, { offline = true })
end, { desc = '[P]ack [l]ist' })

vim.keymap.set('n', '<leader>Ps', function()
  vim.pack.update(nil, { target = 'lockfile' })
end, { desc = '[P]ack [s]ync' })
