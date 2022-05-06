# Snowball

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
    provider = snowball.provider_name,
    update = 'BufWrite',
    hl = { fg = 'yellow' },
    truncate = true,
    right_sep = ' ',
    left_sep = ' ',
  }
}

require'feline'.setup {
  custom_providers = { [snowball.provider_name] = snowball.provider },
  components = snowball.add_whitespace_components(require'feline.presets'.default),
}
```

There are also some convenience methods and tables to make debugging and custom configuration easier in certain cases.

```lua
print(snowball.provider()) -- show the current output of the provider
print(vim.pretty_print(snowball.get_config())) -- show current config

-- NEEDS NERDFONT { prefix = '', trailing = '﬋', mixed_indent = '' }
print(vim.pretty_print(snowball.labels_alternate))
-- so we can do this:
snowball.setup { labels = snowball.labels_alternate }
-- and then the same needed call to require'feline'.setup as above
```

## Screenshots

Default settings, trailing whitespace (line 400) + space-indented lines (line 435) and tab-indented lines (line 400)

<img width="249" alt="image" src="https://user-images.githubusercontent.com/13181078/166393983-23ad097d-c188-41fa-b950-9f2537f2853d.png">

Default settings, single line with both spaces and tabs in the indentation (line 401)

<img width="135" alt="image" src="https://user-images.githubusercontent.com/13181078/166394130-9607cc19-6f2b-4038-afeb-c8819790f28b.png">

Alternate labels, trailing whitespace (line 401) + space-indented lines (line 400) and tab-indented lines (line 399)

<img width="128" alt="image" src="https://user-images.githubusercontent.com/13181078/166394370-de575f43-fc12-4bc8-9834-619ef2d6def8.png">

## Misc

I also added the function `reverse_scroll_bar(components)` which can be used like so:

```lua
require'feline'setup { components = require'snowball'.reverse_scroll_bar(components) }
``` 

Which will make the usual feline `'scroll_bar'` component go in the oppopsite direction and is based on
[this feline PR](https://github.com/feline-nvim/feline.nvim/pull/261). I find the scrollbar more intuitive and visually
pleasant in reverse.
