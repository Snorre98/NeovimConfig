--[[============================================================================
  plugins/debug.lua — nvim-dap, a visual debugger.

  WHAT: Set breakpoints, step through code, inspect variables — inside Neovim.
  nvim-dap is the engine; nvim-dap-ui draws the panels (variables, call stack,
  breakpoints, REPL).

  KEYMAPS:
    <leader>db → toggle a breakpoint on the current line
    <leader>dc → start / continue
    <leader>di → step into      <leader>do → step over      <leader>dO → step out
    <leader>du → toggle the debugger UI panels

  ADAPTERS: each language needs a "debug adapter". Some come for free:
    - Rust: rustaceanvim wires up debugging automatically (needs `codelldb`,
      install via :MasonInstall codelldb).
    - Python: :MasonInstall debugpy, then `require('dap-python').setup(...)`.
  Add adapter setup here as you need each language. Without an adapter, the
  keymaps still load but a session won't start for that language.
============================================================================--]]

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "nvim-neotest/nvim-nio", -- required by dap-ui
  },
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: breakpoint" },
    { "<leader>dc", function() require("dap").continue() end, desc = "Debug: continue" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Debug: step into" },
    { "<leader>do", function() require("dap").step_over() end, desc = "Debug: step over" },
    { "<leader>dO", function() require("dap").step_out() end, desc = "Debug: step out" },
    { "<leader>du", function() require("dapui").toggle() end, desc = "Debug: toggle UI" },
  },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    dapui.setup()
    -- Auto-open the UI when a debug session starts, close it when it ends.
    dap.listeners.before.attach.dapui_config = dapui.open
    dap.listeners.before.launch.dapui_config = dapui.open
    dap.listeners.before.event_terminated.dapui_config = dapui.close
    dap.listeners.before.event_exited.dapui_config = dapui.close
  end,
}
