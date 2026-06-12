--[[============================================================================
  plugins/finder.lua — Telescope, the fuzzy finder.

  WHAT: This is Zed's Cmd-P / "search everywhere". A floating window where you
  type to fuzzy-match files, text across the project, open buffers, help, etc.

  KEYMAPS (all start with <leader> = Space, except Ctrl-p):
    Ctrl-p  or  <leader>ff  → Find files by name
    <leader>fg              → Live grep: search file CONTENTS across the project
    <leader>fw              → Grep the word under the cursor
    <leader>fb              → Switch between open buffers
    <leader>fh              → Search Neovim's help docs
    <leader>fr              → Recently opened files
  Inside the picker: type to filter, Up/Down or Ctrl-n/Ctrl-p to move,
  Enter to open, Esc to close.

  NOTE: live grep needs ripgrep (`rg`) installed on the machine. Install via
  `brew install ripgrep` / `apt install ripgrep`. :checkhealth telescope warns
  if it's missing.
============================================================================--]]

return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim", -- lua helper library Telescope is built on
    "nvim-tree/nvim-web-devicons", -- file-type icons (needs a Nerd Font)
    -- A compiled fzf sorter for much faster matching. `build` runs `make` once.
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({})
    pcall(telescope.load_extension, "fzf") -- enable the fast sorter if it built

    local builtin = require("telescope.builtin")
    local map = vim.keymap.set
    map("n", "<C-p>", builtin.find_files, { desc = "Find files" })
    map("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
    map("n", "<leader>fg", builtin.live_grep, { desc = "[F]ind by [G]rep (project search)" })
    map("n", "<leader>fw", builtin.grep_string, { desc = "[F]ind [W]ord under cursor" })
    map("n", "<leader>fb", builtin.buffers, { desc = "[F]ind open [B]uffers" })
    map("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
    map("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecent files" })
  end,
}
