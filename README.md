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
