vim.pack.add({ 'https://github.com/nvim-treesitter/nvim-treesitter' })

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(event)
    local name, kind = event.data.spec.name, event.data.kind

    if name == 'nvim-treesitter' and kind =='update' then
      if not event.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end

      vim.cmd('TSUpdate')
    end
  end,
})
