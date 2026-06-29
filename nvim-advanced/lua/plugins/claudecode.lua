--[[============================================================================
  plugins/claudecode.lua — Claude Code integration (coder/claudecode.nvim).

  WHAT: Talks to the Claude Code CLI from inside Neovim over its WebSocket/MCP
  protocol. Toggle a terminal pane, send the current buffer or a visual
  selection as context, and accept/deny the diffs Claude proposes — all without
  leaving the editor. Requires the `claude` CLI on your PATH.

  DEPENDENCY: folke/snacks.nvim provides the terminal UI; lazy.nvim installs it
  automatically because it's listed below.

  LAZY-LOADING: loads on first :ClaudeCode* command or <leader>a* keymap.
  Keymaps live under the <leader>a ("AI") prefix; which-key shows the menu.
============================================================================--]]

return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  config = true, -- initialise with the plugin's sensible defaults
  cmd = {
    "ClaudeCode",
    "ClaudeCodeFocus",
    "ClaudeCodeSelectModel",
    "ClaudeCodeAdd",
    "ClaudeCodeSend",
    "ClaudeCodeTreeAdd",
    "ClaudeCodeStatus",
    "ClaudeCodeStart",
    "ClaudeCodeStop",
    "ClaudeCodeOpen",
    "ClaudeCodeClose",
    "ClaudeCodeDiffAccept",
    "ClaudeCodeDiffDeny",
    "ClaudeCodeCloseAllDiffs",
  },
  keys = {
    { "<leader>a", nil, desc = "AI/Claude Code" },
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select model" },
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send to Claude" },
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
  },
}
