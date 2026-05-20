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

local treesitter = require('nvim-treesitter')
local ensure_installed = {
  'bash',
  'diff',
  'dockerfile',
  'editorconfig',
  'git_config',
  'git_rebase',
  'gitcommit',
  'gitignore',
  'hcl',
  'json',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'ruby',
  'rust',
  'toml',
  'vim',
  'vimdoc',
  'yaml',
}

treesitter.setup({})
treesitter.install(ensure_installed)

for _, parser in ipairs(ensure_installed) do
  local filetypes = parser

  vim.treesitter.language.register(parser, filetypes)

  vim.api.nvim_create_autocmd({ 'FileType' }, {
    pattern = filetypes,
    callback = function(event)
      vim.treesitter.start(event.buf, parser)
    end,
  })
end
