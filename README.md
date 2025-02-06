# streamline.nvim
A lightweight statusline plugin for Neovim focused on essential information with zero dependencies.

## Features

- File information (name, type)
- Git branch
- Vim mode indicator
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
			"filetype",
		},
	},
	excluded_filetypes = {
		"TelescopePrompt",
		"snacks_picker_input",
	},
}
```
