local augroup = vim.api.nvim_create_augroup('personal.base', { clear = true })

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight yank',
  group = augroup,
  callback = function ()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  group = augroup,
  desc = 'OSC11 sync to prevent border around terminal',
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })

    if not normal.bg then
      return
    end

    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

vim.api.nvim_create_autocmd("UILeave", {
  group = augroup,
  desc = 'OSC11 sync to reset border around terminal',
  callback = function()
    io.write("\027]111\027\\")
  end,
})
