vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })

vim.lsp.config('*', {
  capabilities = {
    textDocument = {
      semanticTokens = {
        multilineTokenSupport = true,
      }
    }
  },
  root_markers = { '.git' },
})

--- I experienced some LSP clients freezing up, causing Neovim to hang
--- We have to temporarily disable semantic tokens provider to remediate
--- @see https://github.com/neovim/neovim/issues/36257
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    if client and client.server_capabilities then
      client.server_capabilities.semanticTokensProvider = nil
    end
  end,
})

--- Inline lsp progress
vim.api.nvim_create_autocmd('LspProgress',
  {
    buffer = vim.fn.bufnr(),
    callback = function(ev)
      local value = ev.data.params.value

      vim.api.nvim_echo({ { value.message or 'done' } }, false, {
        id = 'lsp.' .. ev.data.params.token,
        kind = 'progress',
        source = 'vim.lsp',
        title = value.title,
        status = value.kind ~= 'end' and 'running' or 'success',
        percent = value.percentage,
      })
    end,
  }
)

--- Helper function to show LSP status
vim.api.nvim_create_user_command('LspInfo', function()
  vim.cmd('checkhealth vim.lsp')
end, { desc = "Show LSP information" })
