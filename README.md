# Telescope SMB UNC integration
[Telescope](https://github.com/nvim-telescope/telescope.nvim) picker for Windows SMB mapped drive plugin.

## How does it look?
Color scheme is [Darcula](https://github.com/4542elgh/darcula.nvim) made with TJ's colorbuddy plugin
![image](https://user-images.githubusercontent.com/17227723/209452796-b6b0219d-fefe-4a8d-a775-705bb238de69.png)

## Why?
This plugin was created due to my frustration typing out full path of mapped SMB drives.
The easiest way I found was to use `cmd.exe` and entering `net use`, then copy the drive letter.
However, I need to do it so many times it become cumbersome task.
<br/>
I wrote this integration with Telescope to give it fuzzy find and yank to register via Telescope. 
Inspired and modified code from Telescope Vim Bookmark project. It is a relatively simple and easy to understand telescope plugin.

## Installation
If you are using [packer.nvim](https://github.com/wbthomason/packer.nvim), use this to setup `smb_unc`
```lua
use "4542elgh/telescope-smb-unc.nvim"
```

In Telescope setup, require smb_unc module
```lua
require('telescope').load_extension('smb_unc')
```

## Usage

The extension provides the following picker:
```viml
" output current system mapped drive
:Telescope smb_unc
```
Lua equivalent:
```lua
require('telescope').extensions.smb_unc.all()
```
