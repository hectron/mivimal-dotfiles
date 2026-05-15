vim.pack.add({ 'https://github.com/dmtrKovalenko/fff' })

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(event)
    local name, kind = event.data.spec.name, event.data.kind

    if name == 'fff.nvim' and (kind == 'install' or kind == 'update') then
      if not event.data.active then
        vim.cmd.packadd('fff.nvim')
      end

      require('fff.download').download_or_build_binary()
    end
  end,
})

vim.g.fff = {
  lazy_sync = true,
  debug = { enabled = true, show_scores = true },
}

vim.keymap.set('n', '<Leader><Leader>', function() require('fff').find_files() end, { desc = '[FFF] Find files' })
vim.keymap.set('n', '<leader>fg', function() require('fff').live_grep() end, { desc = '[FFF] Live grep' })
vim.keymap.set('n', '<leader>fc', function() require('fff').live_grep({ query = vim.fn.expand('<cword>') }) end, { desc = '[FFF] Search word' })
