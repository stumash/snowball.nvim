# SNOWBALL

A provider-plugin for [feline.nvim](https://github.com/feline-nvim/feline.nvim) that tells you about trailing
whitespace and mixed-indentation.

'Snowball' is a common name for white cats, and this is a whitespace-related add-on for
[feline.nvim](https://github.com/feline-nvim/feline.nvim) :smile_cat:.

# Installation

```vim
Plug 'stumash/badwhitespace.nvim'
```

# Usage

```lua
local snowball = require'snowball'

-- these are the defaults, you can omit this call if you want don't want to change them
snowball.configure_whitespace_component {
  labels = {
    prefix = 'WS'
    trailing = 'trailing',
    mixed_indent = 'mix-indent',
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

require'feline'.setup {
  custom_providers = { whitespace = snowball.provider_name },
  components = snowball.add_whitespace_components(require'feline.presets'.default),
}
```

There are also some convenience methods and tables to make debugging and custom configuration easier in certain cases.

```lua
print(vim.pretty_print(snowball.get_config())) -- show current config
print(vim.pretty_print(snowball.labels_alternate)) -- { prefix = 'WS ', trailing = '﬋', mixed_indent = '' }
-- so we can do this:
snowball.configure_whitespace_component { labels = snowball.labels_alternate }
-- and then the same needed call to require'feline'.setup as above
```
