# streamline.nvim
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

## Credits 👤

Status line and theme design adapted from [poimandres.nvim](https://github.com/olivercederborg/poimandres.nvim) and [yugen.nvim](https://github.com/bettervim/yugen.nvim).
