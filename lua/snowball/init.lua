local utils = require'snowball.utils'
local config = require'snowball.config'

local M = {}

M.setup = config.setup
M.get_config = config.get_config
M.labels_alternate = config.labels_alternate
M.provider_name = config.provider_name

M.provider = utils.whitespace_provider
M.add_whitespace_component = utils.add_whitespace_component
M.reverse_scroll_bar = utils.reverse_scroll_bar

return M
