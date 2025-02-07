# streamline.nvim
A lightweight statusline plugin for Neovim focused on essential information with optional dependencies.

<img width="1297" alt="Screenshot 2025-02-07 at 10 39 31" src="https://github.com/user-attachments/assets/631d0d6d-ea0b-420f-97c2-9ac9710f1ff3" />

## Features

- File information (name, type)
- Git branch
- Vim mode indicator
- indentation (tabs vs spaces)
- Customizable highlights
- Supports multiple icon providers ([mini.icons](https://github.com/echasnovski/mini.icons) or [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons))

## Installation 

Lazy
```lua
{
    "drgfunk/streamline.nvim", 

    -- optional icon provider dependency
    -- either echasnovski/mini.icons or nvim-tree/nvim-web-devicons
    -- mini.icons is preferred if more than one icon provider is loaded
    dependencies = { { "echasnovski/mini.icons", opts = {} } },

    branch = "main",
    opts = {}
}
```

Packer
```lua
{
    "drgfunk/streamline.nvim", 
    branch = "main",
    config = function()
        require("streamline").setup() 
    end
}
```

Plug
```lua
{ "drgfunk/streamline.nvim" , { 'branch': 'main' } }
```

Default Options
```
{
    sections = {
        left = {
            "mode",
            "git_branch",
            "filename",
        },
        middle = {},
        right = {
            "indent",
            "filetype",
        },
    },
    -- The status line will be hidden for these buffers
    excluded_filetypes = {
        "TelescopePrompt",
        "snacks_picker_input",
    },
}
```

## Credits

Status line and theme design adapted from [poimandres.nvim](https://github.com/olivercederborg/poimandres.nvim) and [yugen.nvim](https://github.com/bettervim/yugen.nvim).
