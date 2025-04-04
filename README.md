# streamline.nvim
A lightweight statusline plugin for Neovim focused on essential information with optional dependencies.

<img width="1297" alt="Screenshot 2025-03-20 at 09 22 19" src="https://github.com/user-attachments/assets/58411cd8-f798-421a-b0d3-168d99f8ddf8" />

## Features

- File information (name, type)
- Git branch
- Vim mode indicator
- Macro recording indicator
- indentation (tabs or spaces)
- Customizable highlights
- Supports multiple icon providers ([mini.icons](https://github.com/echasnovski/mini.icons) or [nvim-web-devicons](https://github.com/nvim-tree/nvim-web-devicons))

## Additional Utilities

Streamline.nvim also includes helpful utility commands:

### JavaScript/TypeScript Require-to-Import Conversion

Quickly convert CommonJS require statements to ES6 import syntax:

```javascript
// Before:
const myModule = require("my-module")

// After:
import myModule from "my-module"
```

**Usage:**
- Use the `:StreamlineConvertRequire` command when your cursor is on a require statement
- Works only in JavaScript and TypeScript files
- Supports repetition with vim-repeat plugin

**Configuration:**
```lua
-- Optional key mapping 
vim.keymap.set("n", "<Leader>cr", "<Plug>(StreamlineConvertRequire)", { silent = true })
```

### Word Replacement Utility

Replace all instances of the word under cursor across the file:

**Usage:**
- Use the `:StreamlineReplace` command when your cursor is on a word
- Enter the replacement text in the prompt
- All instances will be replaced while maintaining cursor position

**Dependencies:**
- Requires the `snacks` plugin for the input prompt

**Configuration:**
```lua
-- Optional key mapping
vim.keymap.set("n", "<Leader>rr", ":StreamlineReplace<CR>", { silent = true })
```

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

## Configuration

Default Options
```lua
{
    sections = {
        left = {
            "mode",
            "git_branch",
            "filename",
        },
        middle = {
            "macro"
        },
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
    -- Configure with mini.icons (default) or nvim-web-devicons
    icon_provider = "mini.icons",
}
```

## Colors
| Highlight Group | Description |
| --- | --- |
| **StreamlineBar** | Background for the Streamline bar |
| **StreamlineMode** | Vim file mode component |
| **StreamlineGitBranch** | Git branch component and icon |
| **StreamlineFilename** | File name |
| **StreamlineModified** | Icon when file is modified |
| **StreamlineFiletype** | File type, icon color determined by icon provider |
| **StreamlineIndent** | Indentation component |
| **StreamlineMacro** | Space before recording icon |
| **StreamlineMacroText** | The text after recording icon |
| **StreamlineMacroIcon** | The recording icon |
| **StreamlineSpinnerCircle** | Circle spinner animation |
| **StreamlineSpinnerRecordingOn** | Recording spinner when active |
| **StreamlineSpinnerRecordingOff** | Recording spinner when inactive |
| **StreamlineCodecompanionText** | Text shown for the CodeCompanion component |
| **StreamlineSpinnerDotProgressOn** | Dot progress spinner when active |
| **StreamlineSpinnerDotProgressOff** | Dot progress spinner when inactive |


## Credits

Status line and theme design adapted from [poimandres.nvim](https://github.com/olivercederborg/poimandres.nvim) and [yugen.nvim](https://github.com/bettervim/yugen.nvim).
