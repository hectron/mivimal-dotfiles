-- Escape insert mode with jj
vim.keymap.set('i', 'jj', '<Esc>')

-- <CR> completion option
vim.keymap.set('i', '<CR>', function()
  if vim.fn.pumvisible() == 1 then
    return '<C-y>'
  end

  return '<CR>'
end, { expr = true, desc = 'Completion: Accept completion or new line'})

-- Neovim News
vim.keymap.set('n', '<leader>N', '<cmd>help news<cr>', { desc = 'Neovim [N]ews' })

-- Vim pack keymap
vim.keymap.set('n', '<leader>Pl', function()
  vim.pack.update(nil, { offline = true })
end, { desc = '[P]ack [l]ist' })

vim.keymap.set('n', '<leader>Ps', function()
  vim.pack.update(nil, { target = 'lockfile' })
end, { desc = '[P]ack [s]ync' })
