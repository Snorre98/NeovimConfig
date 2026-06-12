--[[============================================================================
  plugins/editing.lua — small editing comforts + the statusline.

  Three independent plugins bundled here because each is tiny:

  1. mini.pairs    → auto-inserts the closing ) ] } " ' as you type the opener.
  2. mini.surround → add/change/delete surrounding quotes & brackets:
        saiw"  → surround inner word with "quotes"   (sa = surround add)
        sd"    → delete surrounding "quotes"          (sd = surround delete)
        sr"'   → change surrounding " to '            (sr = surround replace)
  3. lualine       → the status bar at the bottom (mode, file, git, position).

  COMMENTING is built into Neovim itself (no plugin needed):
        gcc  → toggle comment on the current line
        gc   → toggle comment on a visual selection / with a motion (e.g. gcap)
============================================================================--]]

return {
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.pairs").setup()
      require("mini.surround").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "tokyonight",
        section_separators = "",  -- flat, minimal, Zed-like look
        component_separators = "",
      },
    },
  },
}
