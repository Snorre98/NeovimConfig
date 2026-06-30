--[[============================================================================
  plugins/lsp.lua — Language Server Protocol (LSP) setup (ADVANCED).

  Same idea as the nooby config (mason installs servers, mason-lspconfig
  enables them, nvim-lspconfig provides settings, blink.cmp gets the
  capabilities). Two differences in the advanced config:

    - rust_analyzer is NOT listed here — the rustaceanvim plugin (rust.lua)
      manages the Rust server itself with extra features. Don't double-config it.
    - Java (jdtls) is NOT listed here — nvim-jdtls (java.lua) launches it
      per-project because Java needs special startup handling.

  KEYMAPS (active when a server attaches):
    gd  go-to-def   gr  references   gI  implementation   K  hover
    <leader>rn rename   <leader>ca code action   [d / ]d  prev / next diagnostic
============================================================================--]]

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "mason-org/mason-lspconfig.nvim",
    "saghen/blink.cmp",
  },
  config = function()
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

        -- Code Lens auto-refresh (e.g. markdown-oxide reference counts)
        local function codelens_supported(bufnr)
          for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
            if c.server_capabilities and c.server_capabilities.codeLensProvider then
              return true
            end
          end
          return false
        end
        if codelens_supported(event.buf) then
          vim.lsp.codelens.refresh({ bufnr = event.buf })
          vim.api.nvim_create_autocmd(
            { "TextChanged", "InsertLeave", "CursorHold", "BufEnter" },
            {
              buffer = event.buf,
              callback = function()
                if codelens_supported(event.buf) then
                  vim.lsp.codelens.refresh({ bufnr = event.buf })
                end
              end,
            }
          )
        end

        -- Daily note command for markdown-oxide
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client and client.name == "markdown_oxide" then
          pcall(vim.api.nvim_create_user_command, "Daily", function(args)
            vim.lsp.buf.execute_command({ command = "jump", arguments = { args.args } })
          end, { desc = "Open daily note", nargs = "*" })
        end
      end,
    })

    vim.lsp.config("*", {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
    })

    vim.lsp.config("lua_ls", {
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      },
    })

    -- markdown-oxide: merge extra capabilities for dynamic file watching
    vim.lsp.config("markdown_oxide", {
      capabilities = vim.tbl_deep_extend(
        "force",
        require("blink.cmp").get_lsp_capabilities(),
        {
          workspace = {
            didChangeWatchedFiles = {
              dynamicRegistration = true,
            },
          },
        }
      ),
    })

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "ts_ls",
        "html",
        "cssls",
        "tailwindcss",
        "jsonls",
        "pyright",
        "ruff",
        "gopls",
        "clangd",
        "yamlls",
        "markdown_oxide",-- Markdown PKM (wiki-links, backlinks, daily notes)
        -- rust_analyzer → handled by rustaceanvim (rust.lua)
        -- jdtls         → handled by nvim-jdtls    (java.lua)
      },
    })
  end,
}
