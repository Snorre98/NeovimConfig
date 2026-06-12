--[[============================================================================
  init.lua — the FIRST file Neovim runs for the "nooby" config.

  Neovim reads this automatically from ~/.config/nvim/init.lua.
  Its only job is to load our other files in the right order:

    1. options  — how the editor behaves (numbers, clipboard, tabs…)
    2. keymaps  — our custom keyboard shortcuts
    3. lazy     — bootstraps the plugin manager, which then loads everything
                  in lua/plugins/ automatically.

  `require("x")` loads the file lua/x.lua (or lua/x/init.lua). Dots are folders:
  `require("config.options")` loads lua/config/options.lua.
============================================================================--]]

-- Leader key MUST be set before plugins load, because many plugins read it at
-- setup time to register their <leader>… shortcuts. Space is the de-facto
-- community standard and what tutorials assume.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.lazy") -- this one installs/loads all plugins; keep it last.
