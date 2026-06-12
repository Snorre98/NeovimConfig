--[[============================================================================
  config/keymaps.lua — custom keyboard shortcuts (the non-plugin ones).

  Plugin-specific keys (find files, file tree, LSP…) live in their own plugin
  files so each shortcut sits next to the thing it controls. THIS file holds
  the editor-wide basics.

  Syntax:  vim.keymap.set(mode, keys, action, { desc = "shown in which-key" })
    mode: "n"=normal, "i"=insert, "v"=visual, "x"=visual-block, "t"=terminal.
  <leader> = Space (set in init.lua).
============================================================================--]]

local map = vim.keymap.set

-- Clear search highlight by pressing <Esc> in normal mode.
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- ── Save (Zed-like Ctrl-s) ───────────────────────────────────────────────--
-- Works in normal AND insert mode, then drops you back to normal mode.
map({ "n", "i", "v" }, "<C-s>", "<cmd>write<CR><Esc>", { desc = "Save file" })

-- ── Window navigation with Ctrl + h/j/k/l (move between splits) ──────────--
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- ── Move selected lines up/down with Alt-j / Alt-k (Zed/VSCode habit) ────--
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Keep the selection after indenting in visual mode (re-press < or > easily).
map("v", "<", "<gv", { desc = "Indent left, keep selection" })
map("v", ">", ">gv", { desc = "Indent right, keep selection" })

-- Center the screen after jumping half a page or to next search match.
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
map("n", "n", "nzzzv", { desc = "Next search match (centered)" })
map("n", "N", "Nzzzv", { desc = "Prev search match (centered)" })
