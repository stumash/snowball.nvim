# SNOWBALL

A provider-plugin for [feline.nvim](https://github.com/feline-nvim/feline.nvim) that tells you about trailing
whitespace and mixed-indentation.

'Snowball' is a common name for white cats, and this is a whitespace-related add-on for
[feline.nvim](https://github.com/feline-nvim/feline.nvim) :smile_cat:.

## Installation

```vim
Plug 'stumash/snowball.nvim'
```

## Usage

```lua
local snowball = require'snowball'

-- these are the defaults, you can call this function with no arguments if you don't want to change them
snowball.setup {
  labels = {
    prefix = 'WS '
    trailing = 'trailing',
    mixed_indent = 'mix-indent',
  },
  component = {
    provider = snowball.provider_name, -- 'whitespace'
    update = 'BufWrite',
    hl = { fg = 'yellow' },
    truncate = true,
    right_sep = ' ',
    left_sep = ' ',
  }
}

require'feline'.setup {
  custom_providers = { whitespace = snowball.provider },
  components = snowball.add_whitespace_components(require'feline.presets'.default),
}
```

There are also some convenience methods and tables to make debugging and custom configuration easier in certain cases.

```lua
print(snowball.provider()) -- show the current output of the provider
print(vim.pretty_print(snowball.get_config())) -- show current config

print(vim.pretty_print(snowball.labels_alternate)) -- { prefix = '', trailing = '﬋', mixed_indent = '' }
-- so we can do this:
snowball.setup { labels = snowball.labels_alternate }
-- and then the same needed call to require'feline'.setup as above
```

## Screenshots
