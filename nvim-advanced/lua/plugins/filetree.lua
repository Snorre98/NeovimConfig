--[[============================================================================
  plugins/filetree.lua — Neo-tree, the file explorer sidebar.

  WHAT: Zed's project panel — a tree of your files on the left.

  KEYMAP:
    <leader>e  → toggle the tree open/closed

  Inside the tree: Enter opens a file, `a` add file/folder, `d` delete,
  `r` rename, `?` shows ALL the tree's own shortcuts.

  `keys` below means lazy.nvim won't even load this plugin until you first
  press <leader>e — keeps startup fast.
============================================================================--]]

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim", -- UI component library neo-tree uses
  },
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle file [E]xplorer" },
  },
  opts = {
    filesystem = {
      follow_current_file = { enabled = true }, -- highlight the file you're editing
      use_libuv_file_watcher = true,            -- auto-refresh when files change on disk
      filtered_items = { hide_dotfiles = false, hide_gitignored = false },
    },
    window = { width = 32 },
  },
}
