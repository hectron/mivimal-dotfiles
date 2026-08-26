local mini = function(plugin)
  return "https://github.com/nvim-mini/" .. plugin
end

vim.pack.add({
  mini("mini.ai"),
  mini("mini.icons"),
  mini("mini.pairs"),
  mini("mini.surround"),
})

require("mini.ai").setup()
require("mini.icons").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
