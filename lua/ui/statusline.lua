local M = {}

local padding = " "
local seperator = "%="
local git_popup_win

local icon = {
  branch = { "DiagnosticOk", tools.ui.icons.branch },
  fileinfo = { "Keyword", tools.ui.icons.document },
  nomodifiable = { "DiagnosticWarn", tools.ui.icons.bullet },
  modified = { "DiagnosticError", tools.ui.icons.bullet },
  readonly = { "DiagnosticWarn", tools.ui.icons.lock },
  error = { "DiagnosticError", tools.ui.icons.error },
  warn = { "DiagnosticWarn", tools.ui.icons.warning },
  visual = { "DiagnosticInfo", "‹› " },
}

for k, v in pairs(icon) do
  icon[k] = color_utils.wrap_in_highlight(v[2], v[1])
end

local function esc_str(str)
  return str:gsub("([%(%)%%%+%-%*%?%[%]%^%$])", "%%%1")
end

local file_icon_for = function(fname)
  local icon, hl, _ = MiniIcons.get("file", fname)

  return table.concat({
    color_utils.wrap_in_highlight(icon, hl)
  })
end

local function git_popup_icon()
  local open = git_popup_win and vim.api.nvim_win_is_valid(git_popup_win)

  return open and "󰘕" or "󰘖"
end

local render_project = function(root, filename)
  local icon
  local project_path

  if not root then
    icon, _ = MiniIcons.get("directory", filename)
    project_path = vim.fs.dirname(filename)
  else
    icon, _ = MiniIcons.get("directory", root)
    project_path = vim.fs.basename(root)
  end

  return table.concat({
    padding,
    icon,
    padding,
    project_path,
    " ›",
  })
end

local render_path = function(root, fname)
  local filename = vim.fn.fnamemodify(fname, ":t")

  if filename == "" then
    filename = "[No Name]"
  end

  local filename_with_icon = file_icon_for(fname) .. padding .. filename

  if vim.bo.buftype == "help" then
    return filename_with_icon
  end

  if root then
    local dir_path = vim.fn.fnamemodify(fname, ":h") .. tools.os_sep
    dir_path = dir_path:gsub("^" .. esc_str(root) .. tools.os_sep, "")

    return dir_path .. padding .. filename_with_icon
  end

  return filename_with_icon
end

local render_git_info = function(root)
  if not root then
    return ""
  end

  local state = tools.get_git_state(root)

  if not state then
    return tools.ui.icons.branch .. "[NO REPO]"
  end

  local status = state.head .. " "

  if state.oid == "(initial)" then
    status = status .. "[UNBORN]"
  elseif state.head == "(detached)" then
    status = string.format("%s [DETACHED HEAD]", state.oid:sub(1, 7))
  else
    local divergence = tools.git_divergence(state)
    status = status .. divergence
  end

  return table.concat({
    "%@v:lua.StatuslineGitClick@",
    tools.ui.icons.branch,
    status,
    "  ",
    color_utils.wrap_in_highlight(git_popup_icon(), "Comment"),
    "%T",
    "  ",
  })
end
local render_diagnostics = function() end

local render_file_info = function()
  local filetype = vim.api.nvim_get_option_value("filetype", {})
  local lines = tools.group_number(vim.api.nvim_buf_line_count(0), ",")
  local str = tools.ui.icons.document .. " "

  if not tools.nonprog_modes[filetype] then
    return str .. string.format("%3s lines", lines)
  end

  local word_count = vim.fn.wordcount()

  if not word_count.visual_words then
    return str .. string.format(
      "%3s lines  %3s words",
      lines,
      tools.group_number(word_count.words, ",")
    )
  end

  local virual_lines = math.abs(vim.fn.line(".") - vim.fn.line("v")) + 1

  return str .. string.format(
    "%3s lines %3s words  %3s chars",
    tools.group_number(virual_lines, ","),
    tools.group_number(word_count.visual_words, ","),
    tools.group_number(word_count.visual_chars, ",")
  )
end

local render_scrollbar = function()
  local cur = vim.fn.line('.')
  local total = vim.fn.line('$')
  if cur == 1 then
    return 'Top'
  elseif cur == total then
    return 'Bot'
  else
    return string.format('%2d%%%%', math.floor(cur / total * 100))
  end
end

local build_from_components = function(component_order, components)
  local parts = {}
  local i = 1

  for _, k in ipairs(component_order) do
    local component = components[k]

    if component and component ~= "" then
      parts[i] = component
      i = i + 1
    end
  end

  return table.concat(parts, " ")
end

M.render = function()
  local buffer_filepath = vim.api.nvim_buf_get_name(0)
  local root = (vim.bo.buftype == "" and tools.get_path_root(buffer_filepath)) or nil

  if vim.bo.buftype ~= "" and vim.bo.buftype ~= "help" then
    buffer_filepath = vim.bo.ft
  end

  local buf = vim.api.nvim_win_get_buf(0)

  local components = {
    padding = padding,
    project = render_project(root, buffer_filepath),
    path = render_path(root, buffer_filepath),
    -- git = render_git_info(root),
    modifiable = vim.api.nvim_get_option_value("modifiable", { buf = buf })
        and (vim.api.nvim_get_option_value("modified", { buf = buf }) and icon.modified or "")
        or icon.nomodifiable,
    read_only = vim.api.nvim_get_option_value("readonly", { buf = buf }) and icon.readonly or "",
    seperator = seperator,
    diagnostics = render_diagnostics(),
    file_info = render_file_info(),
    scrollbar = render_scrollbar(),
  }

  local component_order = {
    "padding",
    "git",
    "project",
    "path",
    "modifiable",
    "read_only",
    "seperator",
    "diagnostics",
    "file_info",
    "padding",
    "scrollbar",
    "padding",
  }

  return build_from_components(component_order, components)
end

vim.opt.statusline = "%!v:lua.require('ui.statusline').render()"

return M
