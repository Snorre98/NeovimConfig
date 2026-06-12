--[[============================================================================
  plugins/ui.lua — visual polish.

  1. noice.nvim     → prettier command-line, messages, and LSP popups (a more
                      modern, less cluttered UI). Uses nvim-notify for toasts.
  2. todo-comments  → highlights TODO / FIXME / HACK / NOTE / WARN comments and
                      lets you jump between them.
        ]t / [t   → next / previous TODO comment
  3. indent-blankline → faint vertical lines showing indentation levels.
============================================================================--]]

return {
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      presets = { lsp_doc_border = true },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous TODO comment" },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
}
