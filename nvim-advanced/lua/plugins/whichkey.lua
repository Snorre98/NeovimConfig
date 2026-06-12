--[[============================================================================
  plugins/whichkey.lua — which-key, the live keymap helper.

  WHAT: Start a shortcut (e.g. press <Space>) and a popup lists every key you
  can press next, with descriptions. This is the single best tool for LEARNING
  the config — you don't have to memorise anything; the editor shows you.

  The descriptions come from the `desc = "..."` on every keymap we define.
  The `spec` below just gives nicer names to the leader-key GROUPS.

  `event = "VeryLazy"` loads it shortly after startup (not blocking launch).
============================================================================--]]

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>f", group = "Find (Telescope)" },
      { "<leader>c", group = "Code (LSP / format)" },
      { "<leader>g", group = "Git" },
      { "<leader>h", group = "Harpoon" },
      { "<leader>d", group = "Debug" },
      { "<leader>x", group = "Diagnostics (Trouble)" },
      { "<leader>r", group = "Rename" },
    },
  },
}
