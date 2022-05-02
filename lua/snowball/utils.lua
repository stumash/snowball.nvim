local get_config = require'snowball.config'.get_config

local M = {}

local function search(pattern) return vim.fn.search(pattern, 'nw') end

-- find the first line with traililng whitespace
-- @return line number of matching line, else 0
function first_trailing_whitespace_line()
  return search[[\s$]]
end

-- find the first line with mixed indentation
-- @return line number of matching line, else 0
function first_mix_indent_line()
  local tst = [[(^\t* +\t\s*\S)]]
  local tls = string.format([[(^\t+ {%d,}\S)]], vim.bo.tabstop)
  local pattern = string.format([[\v%s|%s]], tst, tls)
  return search(pattern)
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
      add_to_s(labels.mixed_indent .. ':' .. mix)
    end

    return labels.prefix .. s
  end
end

-- @param table components: a table of feline components
-- @param number side: on which side of the feline status bar should have the whitespace component (1=left, 2=right)? (default=2)
-- @param number pos: in which position (left-to-right, 1 to N) of the chosen side should the compoenent be? (default=1)
-- @return new feline components table with a whitespace component as the firs elem on the right
function M.add_whitespace_component(components, side, pos)
  if side == nil then side = 2 end -- default to right side of status bar
  if pos == nil then pos = 1 end -- default to first (leftmost) component of components on a given side

  local my_components = {
    active = vim.deepcopy(components.active),
    inactive = vim.deepcopy(components.inactive),
  }
  table.insert(my_components.active[side], pos, get_config().component)
  return my_components
end

return M
