local M = {}

local padding = " "
local seperator = "%="


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

local render_path = function() end
local render_git_info = function() end
local render_diagnostics = function() end
local render_file_info = function() end
local render_scrollbar = function() end

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

  local components = {
    padding = padding,
    project = render_project(root, buffer_filepath),
    path = render_path(),
    git = render_git_info(),
    modifiable = "",
    read_only = "",
    seperator = seperator,
    diagnostics = render_diagnostics(),
    file_info = render_file_info(),
    scrollbar = render_scrollbar(),
  }

  local component_order = {
    "padding",
    "git",
    "project",
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
