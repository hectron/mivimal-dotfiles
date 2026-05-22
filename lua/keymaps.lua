-- Escape insert mode with jj
vim.keymap.set('i', 'jj', '<Esc>')

-- <CR> nearest completion option
vim.keymap.set('i', '<CR>', function ()
  if vim.fn.pumvisible() == 0 then
    return '<CR>'
  end

  if vim.fn.complete_info({ 'selected' }).selected == -1 then
    return '<C-n><C-y>'
  end

  return '<C-y>'
end, { expr = true, desc = 'Completion: Accept completion or new line'})

-- Neovim News
vim.keymap.set('n', '<leader>N', '<cmd>help news<cr>', { desc = 'Neovim [N]ews' })

vim.keymap.set('n', '<leader>Pl', function()
  vim.pack.update(nil, { offline = true })
end, { desc = '[P]ack [l]ist' })

vim.keymap.set('n', '<leader>Ps', function()
  vim.pack.update(nil, { target = 'lockfile' })
end, { desc = '[P]ack [s]ync' })
