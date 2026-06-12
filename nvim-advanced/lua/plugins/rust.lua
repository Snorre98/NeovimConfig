--[[============================================================================
  plugins/rust.lua — rustaceanvim, enhanced Rust support.

  WHY A WHOLE FILE? rustaceanvim wraps rust_analyzer with Rust-specific extras
  (run/test/debug a target from the cursor, macro expansion, better inlay
  hints). It configures the server ITSELF — that's exactly why rust_analyzer is
  left out of lsp.lua, so the two don't fight.

  Nothing to call: just having this plugin installed activates it for Rust
  files. It uses the rust_analyzer from your Rust toolchain (install Rust via
  https://rustup.rs). The standard LSP keymaps (gd, K, …) work as usual.

  Extra: <leader>cR opens the "Rust actions" menu (runnables, expand macro, …).
============================================================================--]]

return {
  "mrcjkb/rustaceanvim",
  version = "^6", -- pin to a stable major series
  ft = "rust",
  config = function()
    vim.g.rustaceanvim = {
      server = {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp("codeAction")
          end, { buffer = bufnr, desc = "Rust: code actions" })
        end,
      },
    }
  end,
}
