# streamline.nvim
A lightweight statusline plugin for Neovim focused on essential information with zero dependencies.

<img width="1297" alt="Screenshot 2025-02-06 at 18 35 39" src="https://github.com/user-attachments/assets/a86e5e4b-e976-406f-bf1a-5efd7c4194ce" />

## Features

- File information (name, type)
- Git branch
- Vim mode indicator
- indentation (tabs vs spaces)
- Customizable highlights

## Installation 

Lazy
```lua
{
    "drgfunk/streamline.nvim", 
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
