local augroup = vim.api.nvim_create_augroup("personal.base", { clear = true })

vim.api.nvim_create_autocmd("UIEnter", {
  desc = "Render custom UI elements (status bar)",
  group = augroup,
  callback = function()
    require("ui")
  end,
})

vim.api.nvim_create_autocmd("UIEnter", {
  desc = "Enable new experimental ui2 UI",
  group = augroup,
  callback = function()
    require("vim._core.ui2").enable()
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight yank",
  group = augroup,
  callback = function()
    vim.hl.on_yank()
  end,
})

vim.api.nvim_create_autocmd("UIEnter", {
  desc = "Use the new ui2 interface",
  group = augroup,
  callback = function()
    require('vim._core.ui2').enable()
  end,
})

vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  desc = "OSC11 sync to prevent border around terminal",
  group = augroup,
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })

    if not normal.bg then
      return
    end

    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

vim.api.nvim_create_autocmd("UILeave", {
  desc = "OSC11 sync to reset border around terminal",
  group = augroup,
  callback = function()
    io.write("\027]111\027\\")
  end,
})
