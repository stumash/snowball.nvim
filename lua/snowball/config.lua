local M = {}

local function copy_values(from, into)
  for k,v in pairs(from) do
    into[k] = vim.deepcopy(v)
  end
end

M.provider_name = 'whitespace'

local config = {}
local default_config = {
  labels = {
    prefix = 'WS ',
    trailing = 'trailing',
    mixed_indent = 'mix-indent',
  },
  component = {
    provider = M.provider_name,
    update = 'BufWrite',
    hl = { fg = 'yellow' },
    truncate = true,
    right_sep = ' ',
    left_sep = ' ',
  }
}

M.labels_alternate = {
  prefix = '',
  trailing = '﬋',
  mixed_indent = '',
}

-- let the user cofigure the component
function M.setup(user_config)
  -- default config
  copy_values(default_config, config)
  -- user-provided labels
  if user_config ~= nil then
    copy_values(user_config, config)
  end
end

function M.get_config()
  return vim.deepcopy(config)
end

return M
