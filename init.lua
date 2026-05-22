vim.cmd.colorscheme([[catppuccin]])

require('options')
require('globals')
require('keymaps')
require('autos')

-- experimental UI
require('vim._core.ui2').enable()

--- OSC 11 sync to prevent the tiny border around the terminal
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })

    if not normal.bg then
      return
    end

    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

vim.api.nvim_create_autocmd("UILeave", {
  callback = function()
    io.write("\027]111\027\\")
  end,
})
