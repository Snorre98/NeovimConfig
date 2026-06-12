--[[============================================================================
  plugins/completion.lua — blink.cmp, the autocomplete popup.

  WHAT: The dropdown of suggestions as you type — from the LSP (language
  server), file paths, snippets, and words in open buffers. Modern, fast,
  minimal config. The LSP plugin (lsp.lua) feeds it.

  KEYMAPS (the "super-tab" preset — feels like most editors):
    Tab / Shift-Tab → accept / move through the suggestions
    Up / Down or Ctrl-p / Ctrl-n → move selection
    Ctrl-Space → open the menu manually / toggle docs
    Enter → accept
    Ctrl-e → dismiss

  `version = "1.*"` downloads a prebuilt fuzzy-matching binary (no Rust
  toolchain needed).
============================================================================--]]

return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" }, -- a big library of ready snippets
  version = "1.*",
  opts = {
    keymap = { preset = "super-tab" },
    appearance = { nerd_font_variant = "mono" },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 200 },
    },
    -- Order matters: LSP suggestions first, then paths, snippets, buffer words.
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
    fuzzy = { implementation = "prefer_rust_with_warning" },
  },
}
