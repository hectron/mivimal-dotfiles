vim.pack.add({
  'https://github.com/nvim-mini/mini.ai',
  -- 'https://github.com/nvim-mini/mini.clue',
  'https://github.com/nvim-mini/mini.icons',
  'https://github.com/nvim-mini/mini.pairs',
  'https://github.com/nvim-mini/mini.surround',
})

require('mini.ai').setup()
require('mini.icons').setup()
require('mini.pairs').setup()
require('mini.surround').setup()
