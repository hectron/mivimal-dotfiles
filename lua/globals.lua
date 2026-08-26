vim.g.clipboard = "osc52" --- Better sequence to integrate clipboard with tmux
vim.g.mapleader = " " --- <space> is leader

--- Disable providers that I'm not using
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

_G.tools = {
  ui = {
    icons = {
      branch = " ",
      bullet = "•",
      open_bullet = "○",
      ok = "✔",
      d_chev = "∨",
      ellipses = "…",
      document = "≡",
      lock = "",
      r_chev = ">",
      warning = " ",
      error = " ",
      info = "󰌶 ",
    },
    kind_icons = {
      Array = " 󰅪 ",
      BlockMappingPair = " 󰅩 ",
      Boolean = "  ",
      BreakStatement = " 󰙧 ",
      Call = " 󰃷 ",
      CaseStatement = " 󰨚 ",
      Class = "  ",
      Color = "  ",
      Constant = "  ",
      Constructor = " 󰆧 ",
      ContinueStatement = "  ",
      Copilot = "  ",
      Declaration = " 󰙠 ",
      Delete = " 󰩺 ",
      DoStatement = " 󰑖 ",
      Element = " 󰅩 ",
      Enum = "  ",
      EnumMember = "  ",
      Event = "  ",
      Field = "  ",
      File = "  ",
      Folder = "  ",
      ForStatement = "󰑖 ",
      Function = " 󰆧 ",
      GotoStatement = " 󰁔 ",
      Identifier = " 󰀫 ",
      IfStatement = " 󰇉 ",
      Interface = "  ",
      Keyword = "  ",
      List = " 󰅪 ",
      Log = " 󰦪 ",
      Lsp = "  ",
      Macro = " 󰁌 ",
      MarkdownH1 = " 󰉫 ",
      MarkdownH2 = " 󰉬 ",
      MarkdownH3 = " 󰉭 ",
      MarkdownH4 = " 󰉮 ",
      MarkdownH5 = " 󰉯 ",
      MarkdownH6 = " 󰉰 ",
      Method = " 󰆧 ",
      Module = " 󰅩 ",
      Namespace = " 󰅩 ",
      Null = " 󰢤 ",
      Number = " 󰎠 ",
      Object = " 󰅩 ",
      Operator = "  ",
      Package = " 󰆧 ",
      Pair = " 󰅪 ",
      Property = "  ",
      Reference = "  ",
      Regex = "  ",
      Repeat = " 󰑖 ",
      Return = " 󰌑 ",
      RuleSet = " 󰅩 ",
      Scope = " 󰅩 ",
      Section = " 󰅩 ",
      Snippet = "  ",
      Specifier = " 󰦪 ",
      Statement = " 󰅩 ",
      String = "  ",
      Struct = "  ",
      SwitchStatement = " 󰨙 ",
      Table = " 󰅩 ",
      Terminal = "  ",
      Text = " 󰀬 ",
      Type = "  ",
      TypeParameter = "  ",
      Unit = "  ",
      Value = "  ",
      Variable = "  ",
      WhileStatement = " 󰑖 ",
    },
  },
  nonprog_modes = {
    ["markdown"] = true,
    ["text"] = true,
  },
}

tools.get_path_root = function(filepath)
  if filepath == "" then
    return
  end

  local cached_root = vim.b.path_root

  if cached_root then
    return cached_root
  end

  local root = vim.fs.root(filepath, { ".git" })

  if not root then
    return
  end

  vim.b.path_root = root

  return root
end

local icons_spaced = {}
for key, value in pairs(_G.tools.ui.kind_icons) do
  icons_spaced[key] = value .. " "
end

_G.tools.ui.kind_icons_spaced = icons_spaced
_G.color_utils = require("ui.color_utils")
