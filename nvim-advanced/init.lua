--[[============================================================================
  init.lua — the FIRST file Neovim runs for the "ADVANCED" config.

  Launch it with:  NVIM_APPNAME=nvim-advanced nvim   (or the `nva` alias).
  Neovim then reads this from ~/.config/nvim-advanced/init.lua.

  Same structure as the nooby config on purpose — once you know one, you know
  both. The difference is extra files in lua/plugins/ (git, formatting, linting,
  debugging, Java, Rust, navigation, UI polish).

  Load order:
    1. options  — editor behaviour
    2. keymaps  — custom shortcuts
    3. lazy     — plugin manager; auto-loads everything in lua/plugins/
============================================================================--]]

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")
require("config.keymaps")
require("config.lazy")
