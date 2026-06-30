--[[============================================================================
  plugins/saga.lua — Lspsaga, enhanced LSP UI.

  WHAT: Better UI for LSP actions — peek definitions in a popup, rename with a
  live preview window, code-action menus, call hierarchies, and more. Also
  enables editing linked markdown files in a popup window via markdown-oxide.

  Lazy-loads only when an LSP server first attaches.
============================================================================--]]

return {
  "nvimdev/lspsaga.nvim",
  event = "LspAttach",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {},
}
