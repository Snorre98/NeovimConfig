--[[============================================================================
  plugins/format.lua — conform.nvim, code formatting.

  WHAT: Runs a formatter (prettier, stylua, gofumpt…) on your file. In the
  advanced config it runs automatically ON SAVE, and you can trigger it
  manually with <leader>cf. Formatters are installed by tools.lua via Mason.

  KEYMAP:
    <leader>cf → format the current buffer now

  format_on_save: lsp_format = "fallback" means "use the dedicated formatter
  if one is listed for this filetype; otherwise ask the language server to
  format." If a formatter binary is missing, conform just skips it.
============================================================================--]]

return {
  "stevearc/conform.nvim",
  event = "BufWritePre",
  cmd = "ConformInfo",
  keys = {
    {
      "<leader>cf",
      function() require("conform").format({ async = true, lsp_format = "fallback" }) end,
      desc = "Code: format buffer",
    },
  },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format" },
      go = { "goimports", "gofumpt" }, -- organise imports, then format
      rust = { "rustfmt" },
      -- One list reused for all the web filetypes; stop at the first one found.
      javascript = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      json = { "prettierd", "prettier", stop_after_first = true },
      jsonc = { "prettierd", "prettier", stop_after_first = true },
      html = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      yaml = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
    },
    format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
  },
}
