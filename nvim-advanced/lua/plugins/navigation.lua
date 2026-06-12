--[[============================================================================
  plugins/navigation.lua — move around fast.

  Three plugins:

  1. flash.nvim  → jump anywhere on screen. Press `s` then 2 chars of where you
     want to go; labels appear, press the label to teleport there.
        s   → jump (normal/visual)

  2. harpoon  → pin a handful of files you keep returning to, then jump between
     them instantly (faster than a fuzzy finder for your "main" files).
        <leader>ha → add the current file to the list
        <leader>hh → show the harpoon menu
        <leader>1 .. <leader>4 → jump straight to pinned file 1–4

  3. trouble.nvim  → a tidy, navigable list of all diagnostics/errors.
        <leader>xx → toggle the diagnostics list
        <leader>xX → diagnostics for the current buffer only
============================================================================--]]

return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash jump" },
    },
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()
      local map = vim.keymap.set
      map("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon: add file" })
      map("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: menu" })
      for i = 1, 4 do
        map("n", "<leader>" .. i, function() harpoon:list():select(i) end, { desc = "Harpoon: file " .. i })
      end
    end,
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics (Trouble)" },
    },
    opts = {},
  },
}
