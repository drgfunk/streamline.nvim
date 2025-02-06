# streamline.nvim
## Installation 

Lazy
```lua
{
    "drgfunk/streamline.nvim", 
	branch = "main",
	tag = "1.0.2",
    opts = {}
}
```

Packer
```lua
{
    "drgfunk/streamline.nvim", 
	branch = "main",
	tag = "1.0.2",
    config = function()
        require("streamline").setup() 
    end
}
```

Plug
```lua
"drgfunk/streamline.nvim" , { 'branch': 'main' }, { 'tag': '1.0.2' }
```

Default Options
```
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
}
```
