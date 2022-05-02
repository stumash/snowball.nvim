local utils = require'utils'
local config = require'config'

local M = {}

M.configure_whitespace_component = config.configure_whitespace_component
M.get_config = config.get_config
M.labels_alternate = config.labels_alternate
M.provider_name = require'config'.WS

function M.add_whitespace_component(components)
  local my_components = {
    active = vim.deepcopy(components.active),
    inactive = vim.deepcopy(components.inactive),
  }
  table.insert(my_components.active[2], 1, config.get_config().component)
  return my_components
end

return M
