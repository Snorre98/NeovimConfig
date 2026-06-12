--[[============================================================================
  plugins/colorscheme.lua — the editor theme.

  WHAT: tokyonight, a clean dark theme close to Zed's default feel.
  WHY:  termguicolors (set in options.lua) lets it render full 24-bit colour.

  SWAP IT: replace the spec below with another theme plugin and change the
  `colorscheme` line. e.g. catppuccin:
      { "catppuccin/nvim", name = "catppuccin", priority = 1000 }
      ...then: vim.cmd.colorscheme("catppuccin")
  Browse themes at https://github.com/topics/neovim-colorscheme
============================================================================--]]

return {
  "folke/tokyonight.nvim",
  priority = 1000, -- load before everything else so other UI sees the colours
  config = function()
    require("tokyonight").setup({
      style = "night", -- "night" (darkest), "storm", "moon", or "day" (light)
    })
    vim.cmd.colorscheme("tokyonight")
  end,
}
