local M = {}
local color_utils = require("ui.color_utils")
local pms = vim.api.nvim_get_hl(0, { name = "PmenuSel", link = false })
local dir = vim.api.nvim_get_hl(0, { name = "Directory", link = false })
local vis = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
vim.api.nvim_set_hl(0, "StlMode", { fg = pms.fg, bg = vis.bg })
vim.api.nvim_set_hl(0, "StlGit", { fg = dir.fg, bg = pms.bg })

local modes = {
  n = "NORMAL",
  i = "INSERT",
  v = "VISUAL",
  V = "V-LINE",
  ["\22"] = "V-BLOCK",
  c = "COMMAND",
  t = "TERMINAL",
  R = "REPLACE",
  s = "SELECT",
  S = "S-LINE",
  ["\19"] = "S-BLOCK",
}

M.nvchad_icons = {
  Array = "[]",
  Boolean = "",
  Calendar = "",
  Class = "",
  Codeium = "",
  Color = "󰏘",
  Constant = "",
  Constructor = "",
  Copilot = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "󰜢",
  File = "󰈙",
  Folder = "󰉋",
  Function = "󰊕",
  Interface = "",
  Keyword = "󰌋",
  Method = "󰊕",
  Module = "",
  Namespace = "󰌗",
  Null = "󰟢",
  Number = "",
  Object = "󰅩",
  Operator = "󰆕",
  Package = "",
  Property = "󰜢",
  Reference = "󰈇",
  Snippet = "",
  String = "󰉿",
  Struct = "󰙅",
  Table = "",
  TabNine = "",
  Tag = "",
  Text = "",
  TypeParameter = "",
  Unit = "󰑭",
  Value = "󰎠",
  Version = "",
  Variable = "",
  Watch = "󰥔",
}

M.lazyvim_icons = {
  Array = "",
  Boolean = "󰨙",
  Class = "",
  Codeium = "󰘦",
  Color = "",
  Control = "",
  Collapsed = "",
  Constant = "󰏿",
  Constructor = "",
  Copilot = "",
  Enum = "",
  EnumMember = "",
  Event = "",
  Field = "",
  File = "",
  Folder = "",
  Function = "󰊕",
  Interface = "",
  Key = "",
  Keyword = "",
  Method = "󰊕",
  Module = "",
  Namespace = "󰦮",
  Null = "",
  Number = "󰎠",
  Object = "",
  Operator = "",
  Package = "",
  Property = "",
  Reference = "",
  Snippet = "",
  String = "",
  Struct = "󰆼",
  TabNine = "󰏚",
  Text = "",
  TypeParameter = "",
  Unit = "",
  Value = "",
  Variable = "󰀫",
}

M.git_icons = {
  added = " ",
  modified = " ",
  removed = " ",
}

M.diagnostic_icons = {
  Error = " ",
  Warn = " ",
  Info = " ",
  Hint = "󰌵 ",
}

M.devicons_override = {
  default_icon = {
    icon = "󰈚",
    name = "Default",
    color = "#E06C75",
  },
  toml = {
    icon = "",
    name = "toml",
    color = "#61AFEF",
  },
  tsx = {
    icon = "",
    name = "Tsx",
    color = "#20c2e3",
  },
  gleam = {
    icon = "",
    name = "Gleam",
    color = "#FFAFF3",
  },
  py = {
    icon = "",
    color = "#519ABA",
    cterm_color = "214",
    name = "Py",
  },
}

local function render_filename()
  local filename = vim.fn.expand("%:f")
  local icon, icon_hl, _ = MiniIcons.get("file", filename)

  -- TODO separate if the path is too long
  if filename:len() > 30 then
    local os_sep = package.config:sub(1, 1)
    local parts = vim.split(filename, os_sep, { plain = true })

    if #parts > 2 then
      local actual_filename = parts[#parts]
      filename = parts[1] .. os_sep .. ".." .. os_sep .. actual_filename
    end
  end

  if not icon and not icon_hl then
    icon, icon_hl = M.devicons_override.default_icon.icon, M.devicons_override.default_icon.name
  end

  local output = filename .. " " .. color_utils.wrap_in_highlight(icon, icon_hl)

  return output
end

function _G._statusline()
  local mode = modes[vim.fn.mode()] or vim.fn.mode():upper()
  local branch = vim.b.git_branch and "%#StlGit# " .. vim.b.git_branch .. " %*" or ""
  -- local path = vim.b.rel_path or "%f"
  local path = render_filename()

  local diag = ""
  local counts = vim.diagnostic.count(0) or {}
  local labels = { " ", " ", " ", " " }
  local hls = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" }
  for i = 1, 4 do
    if counts[i] and counts[i] > 0 then
      diag = diag .. "%#" .. hls[i] .. "#" .. labels[i] .. counts[i] .. "%* "
    end
  end
  local filetype = vim.bo.filetype

  local rhs = "%="
  if branch then
    rhs = rhs .. branch
  end

  if diag then
    rhs = rhs .. diag
  end

  if filetype ~= "" then
    local sep = "   "
    local line_count = vim.api.nvim_buf_line_count(0)
    local current_cursor_and_line_max_size = math.floor(math.log(line_count, 10))

    rhs = rhs .. " %L lines" .. sep .. string.format("%%-%dl:%%-%dc", current_cursor_and_line_max_size, current_cursor_and_line_max_size)
    rhs = rhs .. sep .. filetype:upper() .. sep

    if vim.bo.fileencoding ~= "" then
      rhs = rhs .. vim.bo.fileencoding:upper()
    end
  end

  --- return "%#StlMode# " .. mode .. " %*" .. branch .. " " .. path .. "%=" .. diag .. vim.bo.filetype .. " %l:%c"
  return "%#StlMode# " .. mode .. " %*" .. " " .. "%=" .. path .. rhs
end

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null"):gsub("%s+$", "")
    if root ~= "" then
      vim.b.git_branch = vim.fn.system("git branch --show-current 2>/dev/null"):gsub("%s+$", "")
      vim.b.rel_path = vim.fn.expand("%:p"):sub(#root + 2)
    else
      vim.b.git_branch = nil
      vim.b.rel_path = vim.fn.expand("%:p:~")
    end
  end,
})

vim.api.nvim_create_autocmd("DiagnosticChanged", {
  callback = function()
    vim.cmd("redrawstatus!")
  end,
})

vim.o.statusline = "%!v:lua._statusline()"
