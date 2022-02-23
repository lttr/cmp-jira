# cmp-jira

[nvim-cmp](https://github.com/hrsh7th/nvim-cmp) completion source for Jira.

## Getting started

Use your favorit plugin manager to install the plugin:

```lua
use 'https://gitlab.com/msvechla/cmp-jira.git'
```

Then setup the cmp source by following these steps:

```lua
require'cmp'.setup {
  sources = {
    { name = 'cmp_jira' }
  }
}

require("cmp_jira").setup()
```

## Configuration

TODO:

```lua
require("cmp_jira").setup({
    file_types = {"gitcommit"}
})
```
