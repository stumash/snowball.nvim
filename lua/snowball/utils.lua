local get_config = require'config'.get_config

local M = {}

-- find the first line with traililng whitespace
-- @return line number of matching line, else 0
function first_trailing_whitespace_line()
  vim.fn.search([[\s$]], 'nw')
end

-- find the first line with mixed indentation
-- @return line number of matching line, else 0
function first_mix_indent_line()
  local tst = [[(^\t* +\t\s*\S)]]
  local tls = string.format([[(^\t+ {%d,}\S)]], vim.bo.tabstop)
  local pattern = string.format([[\v%s|%s]], tst, tls)
  return vim.fn.search(pattern, 'nw')
end

-- @return the string to add to the statusline
local labels = nil
function M.whitespace_provider()
  local trail = first_trailing_whitespace_line()
  local mix = first_mix_indent_line()

  if trail == 0 and mix == 0 then
    return ''
  else
    local s = ''
    local function add_to_s(s2)
      if s ~= '' then
        s = s .. ',' .. s2
      else
        s = s2
      end
    end

    if labels == nil then -- only get the labels once, the first time the provider is called
      labels = get_config().labels
    end

    if trail ~= 0 then
      add_to_s(labels.trailing .. ':' .. trail)
    end

    if mix ~= 0 then
      add_to_s(labels.mix_indent .. ':' .. mix)
    end

    return labels.prefix .. s
  end
end

return M
