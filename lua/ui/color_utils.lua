local M = {}

---Converts hexadecimal color codes to RGB
---
---@param hex string
---@return table
M.hex_to_rgb = function(hex)
  local _hex = hex:lower()

  return {
    tonumber(_hex:sub(2, 3), 16),
    tonumber(_hex:sub(4, 5), 16),
    tonumber(_hex:sub(6, 7), 16),
  }
end

--- Blends foreground and background colors by alpha to produce a compatible color.
---
--- @param foreground string
--- @param background string
--- @param alpha number
---
--- @return string
M.blend_foreground_and_background = function(foreground, background, alpha)
  alpha = type(alpha) == "string" and (tonumber(alpha, 16) / 0xff) or alpha

  local bg = M.hexToRGB(background)
  local fg = M.hexToRGB(foreground)

  local blendChannel = function(i)
    local val = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, val), 255) + 0.5)
  end

  return string.format("#%02x%02x%02x", blendChannel(1), blendChannel(2), blendChannel(3))
end

M.wrap_in_highlight = function(text, highlight)
  return "%#" .. highlight .. "#" .. text .. "%*"
end

return M
