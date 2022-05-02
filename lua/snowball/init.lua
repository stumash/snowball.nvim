local M = {}

local function copy_values(from, into)
  for k,v in pairs(from) do
    into[k] = vim.deepcopy(v)
  end
end

local WS = 'whitespace'

local config = {}
local default_config = {
  labels = {
    preifx = 'WS'
    trailing = 'trailing', -- or ﬋
    mixed_indent = 'mix-indent', -- or 
  },
  component = {
    provider = WS,
    update = 'BufWrite',
    hl = { fg = 'yellow' },
    truncate = true,
    right_sep = ' ',
    left_sep = ' ',
  }
}

-- let the user cofigure the component
function M.configure_whitespace_component(user_config)
  -- default config
  copy_values(default_config, config)
  -- user-provided labels
  if user_config ~= nil then
    copy_values(user_config, config)
  end
end

function first_trailing_whitespace_line()
  local line = vim.fn.search([[\s$]], 'nw')
  if line == 0 then
    return nil
  else
    return labels.trailing .. line
  end
end

-- return optional string
function first_mix_indent_line()
  local tst = [[(^\t* +\t\s*\S)]]
  local tls = string.format([[(^\t+ {%d,}\S)]], vim.bo.tabstop)
  local pattern = string.format([[\v%s|%s]], tst, tls)
  local line = vim.fn.search(pattern, 'nw')
  if line == 0 then
    return nil
  else
    return labels.mix_indent .. line
  end
end

function M.whitespace_provider()
  local s = ''
  local trail = first_trailing_whitespace_line()
  local mix = first_mix_indent_line()
  local function addToS(s2) if s ~= '' then s = s .. ',' .. s2 else s = s2 end end
  if trail ~= nil then addToS(trail) end
  if mix ~= nil then addToS(mix) end
  return s
end

function M.addWhitespaceComponents(components, user_config)
  local my_components = {
    active = vim.deepcopy(components.active),
    inactive = vim.deepcopy(components.inactive),
  }
  table.insert(my_components.active[2], 1, whitespace_component)
  return my_components
end

require'feline'.setup {
  custom_providers = { whitespace = whitespace_provider },
  components = my_components,
}

return M
