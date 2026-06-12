--[[============================================================================
  plugins/git.lua — Git integration.

  Two plugins:
  1. gitsigns  → shows +/~/- in the gutter for added/changed/removed lines,
                 inline blame, and hunk actions.
  2. neogit    → a full Git UI (stage, commit, push, branches) like magit/Zed's
                 git panel.

  KEYMAPS:
    <leader>gg → open Neogit (the git dashboard)
    ]c  /  [c  → jump to next / previous changed hunk
    <leader>gs → stage the hunk under the cursor
    <leader>gr → reset (undo) the hunk under the cursor
    <leader>gb → show git blame for the current line
    <leader>gp → preview the hunk's diff
============================================================================--]]

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      on_attach = function(buffer)
        local gs = require("gitsigns")
        local function map(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = buffer, desc = desc })
        end
        map("]c", function() gs.nav_hunk("next") end, "Next git hunk")
        map("[c", function() gs.nav_hunk("prev") end, "Previous git hunk")
        map("<leader>gs", gs.stage_hunk, "Git: stage hunk")
        map("<leader>gr", gs.reset_hunk, "Git: reset hunk")
        map("<leader>gp", gs.preview_hunk, "Git: preview hunk")
        map("<leader>gb", function() gs.blame_line({ full = true }) end, "Git: blame line")
      end,
    },
  },
  {
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Neogit",
    keys = {
      { "<leader>gg", "<cmd>Neogit<cr>", desc = "Git: open Neogit" },
    },
    opts = {},
  },
}
