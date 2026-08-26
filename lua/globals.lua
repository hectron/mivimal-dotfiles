vim.g.clipboard = "osc52" --- Better sequence to integrate clipboard with tmux
vim.g.mapleader = " " --- <space> is leader

--- Disable providers that I'm not using
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

local state_cache = setmetatable({}, { __mode = "k" })
local remote_cache = setmetatable({}, { __mode = "k" })

_G.color_utils = require("ui.color_utils")
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

-- insert grouping separators in numbers
-- viml regex: https://stackoverflow.com/a/42911668
-- lua pattern: stolen from Akinsho
tools.group_number = function(num, sep)
  if num < 999 then return tostring(num) end

  num = tostring(num)
  return num:reverse():gsub("(%d%d%d)", "%1" .. sep):reverse():gsub("^,", "")
end

tools.os_sep = package.config:sub(1, 1)
tools.ui.kind_icons_spaced = icons_spaced

local git_cmd = function(root, ...)
  local job = vim.system({ "git", "-C", root, ... }, { text = true }):wait()

  if job.code ~= 0 then
    return nil, job.stderr
  end

  return vim.trim(job.stdout)
end

tools.git_divergence = function(state)
  local parts = {}
  local ahead = state.ahead and state.ahead or 0
  local behind = state.behind and state.behind or 0

  parts[#parts + 1] = color_utils.wrap_in_highlight("↑", "String") .. ahead
  parts[#parts + 1] = color_utils.wrap_in_highlight("↓", "Number") .. behind

  return table.concat(parts, " ")
end

tools.get_git_state = function(root)
  if not root then
    return
  end

  if state_cache[root] then
    return state_cache[root]
  end

  local cmd_out, err = git_cmd(root, "status", "--porcelain=v2", "--branch")

  if not cmd_out then
    return err
  end

  local git_state_lines_arr = vim.split(cmd_out, "\n", {
    plain = true,
    trimempty = true,
  })

  local git_state_tbl = {}

  for _, line in ipairs(git_state_lines_arr) do
    local key, value = line:match("^# branch%.(%S+)%s+(.+)$")
    if key then git_state_tbl[key] = value end
  end

  if git_state_tbl.ab then
    local ahead, behind = git_state_tbl.ab:match("^%+(%d+)%s+%-(%d+)$")

    git_state_tbl.ahead = tonumber(ahead)
    git_state_tbl.behind = tonumber(behind)
  end

  state_cache[root] = git_state_tbl
  return git_state_tbl
end
