--[[============================================================================
  config/lazy.lua — bootstrap the lazy.nvim plugin manager.

  WHAT: lazy.nvim downloads, updates, and lazily-loads our plugins. It also
  writes a lazy-lock.json lockfile pinning exact plugin versions, so every
  machine you clone to gets the *same* setup.

  HOW IT WORKS:
    - The block below clones lazy.nvim itself the first time (it can't install
      itself, so we do it by hand once).
    - `require("lazy").setup({ import = "plugins" })` then tells it to read
      EVERY file in lua/plugins/ and merge their plugin specs together. So to
      add a plugin you just drop a new file in lua/plugins/ — no edits here.
============================================================================--]]

-- Where lazy.nvim gets installed (inside Neovim's data dir, NOT this repo).
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Clone it the first time only.
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

-- Add lazy.nvim to the runtimepath so `require("lazy")` works.
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Import every spec file under lua/plugins/.
  { import = "plugins" },
}, {
  -- Check for plugin updates in the background, but don't nag on every launch.
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
})
