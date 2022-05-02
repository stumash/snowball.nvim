local utils = require'snowball.utils'
local config = require'snowball.config'

local M = {}

M.configure_whitespace_component = config.configure_whitespace_component
M.get_config = config.get_config
M.labels_alternate = config.labels_alternate
M.provider_name = config.provider_name

function M.add_whitespace_component(components)
  config.configure_whitespace_component()

  local my_components = {
    active = vim.deepcopy(components.active),
    inactive = vim.deepcopy(components.inactive),
  }
  table.insert(my_components.active[2], 1, config.get_config().component)
  return my_components
end

return M
