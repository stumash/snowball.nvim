local get_config = require'snowball.config'.get_config

local M = {}

local function search(pattern) return vim.fn.search(pattern, 'nw') end

-- find the first line with traililng whitespace
-- @return line number of matching line, else 0
local function first_trailing_whitespace_line()
  return search[[\s$]]
end

-- find the first line with mixed indentation (both tabs and spaces)
-- @return line number of matching line, else 0
local function first_mix_indent_line()
  local tst = [[(^\t* +\t\s*\S)]]
  local tls = string.format([[(^\t+ {%d,}\S)]], vim.bo.tabstop)
  local pattern = string.format([[\v%s|%s]], tst, tls)
  return search(pattern)
end

-- find the first line of each kind of indentation (space and tab) if indents of both kind are in the buffer
-- @return line numbers of matching lines, else 0,0
local langs = {'arduino', 'c', 'cpp', 'cuda', 'go', 'javascript', 'ld', 'php'}
local function first_mix_indents_file()
  local head_spc = [[\v(^ +)]]
  if vim.tbl_contains(langs, vim.bo.filetype) then
    head_spc = [[\v(^ +\*@!)]]
  end
  local indent_spc = search(head_spc)
  local indent_tabs = search[[\v(^\t+)]]
  return indent_spc, indent_tabs
end

-- @return the string to add to the statusline
local labels = nil
function M.whitespace_provider()
  local trail = first_trailing_whitespace_line()
  local mix = first_mix_indent_line()
  local mix_spc, mix_tab = first_mix_indents_file()

  if trail == 0 and mix == 0 and (mix_spc == 0 or mix_tab == 0) then
    return ''
  else
    local s = ''
    local function add_to_s(s2)
      if s ~= '' then
        s = s .. ' ' .. s2
      else
        s = s2
      end
    end

    if labels == nil then -- only get the labels once, the first time whitespace_provider is called
      labels = get_config().labels
    end

    if trail ~= 0 then
      add_to_s(labels.trailing .. ':' .. trail)
    end

    if mix ~= 0 then
      add_to_s(labels.mixed_indent .. ':' .. mix)
    elseif mix_spc ~= 0 and mix_tab ~= 0 then
      add_to_s(labels.mixed_indent .. ':' .. mix_spc .. ',' .. mix_tab)
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

function M.reverse_scroll_bar(components, bg, fg)
  if bg == nil then bg = 'skyblue' end
  if fg == nil then fg = 'black' end
  for _, component_section_list in ipairs{ components.active, components.inactive } do
    for _, component_section in ipairs(components_section_list) do
      for _, component in ipairs(component_section) do
        if component.provider = 'scroll_bar' then
          component.provider = { name = 'scroll_bar', opts = { reverse = true } }
          component.hl = { style = 'bold', fg = fg, bg = bg }
        end
      end
    end
  end
  return components
end

return M
