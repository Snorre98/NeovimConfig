--[[============================================================================
  plugins/tools.lua — auto-install non-LSP tools via Mason.

  mason-lspconfig (in lsp.lua) installs LANGUAGE SERVERS. But we also want
  FORMATTERS, the Java server, etc. This plugin installs those so the advanced
  config is turnkey on a fresh machine — no manual :MasonInstall needed.

  See what's installed / install more by hand with  :Mason.
============================================================================--]]

return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "mason-org/mason.nvim" },
  opts = {
    ensure_installed = {
      "jdtls",     -- Java language server (launched by java.lua)
      "stylua",    -- Lua formatter
      "prettierd", -- JS/TS/HTML/CSS/JSON/YAML/Markdown formatter (fast daemon)
      "gofumpt",   -- Go formatter (stricter gofmt)
      "goimports", -- Go import organiser
      -- ruff (Python) and rustfmt (Rust) come from the LSP / Rust toolchain.
    },
  },
}
