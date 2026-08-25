vim.pack.add({
  "https://github.com/obsidian-nvim/obsidian.nvim",
})

local workspaces = vim.iter({
      {
        name = "personal",
        path = "~/me/notes"
      },
      {
        name = "work",
        path = os.getenv("WORK_NOTES_DIR")
      }
    })
    :filter(function(workspace)
      return vim.fn.isdirectory(vim.fs.abspath(workspace.path)) == 1
    end)
    :totable()

require("obsidian").setup({
  legacy_commands = false,
  picker = {
    name = "fzf-lua",
  },
  daily_notes = {
    folder = "diary/" .. os.date("%Y"),
    schedule = "calendar",
  },
  workspaces = workspaces,
})

-- NOTE: you don't need this is you are on neovim 0.13 (nightly)
-- HACK: to trigger on every ASCII char
local chars = {}
for i = 32, 126 do
  table.insert(chars, string.char(i))
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client and client.name == "obsidian-ls" then
      client.server_capabilities.completionProvider.triggerCharacters = chars -- HACK:
    end
  end,
})

vim.keymap.set("n", "<leader>od", "<Cmd>Obsidian today<CR>", { desc = "[o]bsidian [d]iary (today)" })
vim.keymap.set("n", "<leader>os", "<Cmd>Obsidian search<CR>", { desc = "[o]bsidian [s]earch" })
vim.keymap.set("n", "<leader>oq", "<Cmd>Obsidian quick_switch<CR>", { desc = "[o]bsidian [q]uick switch" })
vim.keymap.set("n", "<leader>on", "<Cmd>Obsidian new<CR>", { desc = "[o]bsidian [n]ote" })
vim.keymap.set("n", "<leader>ot", "<Cmd>Obsidian tags<CR>", { desc = "[o]bsidian [t]ags" })
vim.keymap.set("n", "<leader>oT", "<Cmd>Obsidian toc<CR>", { desc = "[o]bsidian [T]OC" })
