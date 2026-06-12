--[[============================================================================
  plugins/lsp.lua — Language Server Protocol (LSP) setup.

  WHAT IS LSP? A "language server" is a background program that understands a
  language. It gives you: go-to-definition, hover docs, find-references,
  rename, autocomplete suggestions, and red squiggly error/warning diagnostics.
  Neovim is the CLIENT; these plugins connect the two.

  THE THREE PIECES:
    - mason.nvim          → installs the language servers for you (a package
                            manager for dev tools). Run :Mason to see them.
    - mason-lspconfig     → bridges mason with the configs, and auto-enables
                            each server it installs.
    - nvim-lspconfig      → ships the connection settings for ~200 servers.

  Neovim 0.11 has a built-in LSP config API (`vim.lsp.config` / `vim.lsp.enable`).
  nvim-lspconfig provides the per-server defaults; we layer our tweaks on top.

  KEYMAPS (active only when a server is attached to the current file):
    gd          → Go to definition
    gr          → Find references
    gI          → Go to implementation
    K           → Hover documentation
    <leader>rn  → Rename symbol (everywhere)
    <leader>ca  → Code action (quick fixes)
    [d  /  ]d   → Previous / next diagnostic
============================================================================--]]

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason-lspconfig.nvim",
    "saghen/blink.cmp", -- so we can hand the LSP our completion capabilities
  },
  config = function()
    -- 1) Run our keymaps whenever ANY language server attaches to a buffer.
    vim.api.nvim_create_autocmd("LspAttach", {
      desc = "LSP keymaps",
      callback = function(event)
        local map = function(keys, fn, desc)
          vim.keymap.set("n", keys, fn, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        map("gd", vim.lsp.buf.definition, "Go to definition")
        map("gr", vim.lsp.buf.references, "Find references")
        map("gI", vim.lsp.buf.implementation, "Go to implementation")
        map("K", vim.lsp.buf.hover, "Hover documentation")
        map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
        map("<leader>ca", vim.lsp.buf.code_action, "Code action")
        map("[d", function() vim.diagnostic.jump({ count = -1 }) end, "Previous diagnostic")
        map("]d", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
      end,
    })

    -- 2) Tell every server what our completion engine (blink) can handle.
    --    The "*" config applies to all servers as a base.
    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    -- 3) Per-server tweaks. Most servers need none; lua_ls just needs to know
    --    about the global `vim` variable so it stops warning about it.
    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      },
    })

    -- 4) Which servers to install. mason-lspconfig downloads these and then
    --    auto-enables them (calls vim.lsp.enable) — no extra wiring needed.
    --    Names are nvim-lspconfig names; see :help lspconfig-all.
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",        -- Lua (this config)
        "ts_ls",         -- TypeScript / JavaScript
        "html",          -- HTML
        "cssls",         -- CSS
        "tailwindcss",   -- Tailwind CSS
        "jsonls",        -- JSON
        "pyright",       -- Python (types)
        "ruff",          -- Python (lint/format, fast)
        "gopls",         -- Go
        "rust_analyzer", -- Rust
        "clangd",        -- C / C++
        "yamlls",        -- YAML
        -- Java is NOT here: it needs the special nvim-jdtls launcher, which
        -- lives in the ADVANCED config. Here Java still gets syntax colours
        -- from treesitter, just no language-server features.
      },
    })
  end,
}
