vim.pack.add({ "https://github.com/folke/which-key.nvim" })

require("which-key").setup({
  preset = "helix",
  spec = {
    { "<leader>b", desc = "Buffer" },
    { "<leader>o", desc = "Obsidian" },
  },
})
