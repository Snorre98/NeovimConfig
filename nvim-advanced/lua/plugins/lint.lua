--[[============================================================================
  plugins/lint.lua — nvim-lint, standalone linters.

  WHAT: Some checks aren't covered by the language server. nvim-lint runs an
  external linter and shows its warnings as diagnostics. It runs after you save
  or leave insert mode.

  By default the list below is EMPTY so nothing errors out of the box (your
  LSP servers already lint a lot). To add one: install the linter (e.g.
  `:MasonInstall eslint_d`) and add it under its filetype, e.g.

      lint.linters_by_ft.javascript = { "eslint_d" }
      lint.linters_by_ft.markdown   = { "markdownlint" }

  Find linter names: https://github.com/mfussenegger/nvim-lint#available-linters
============================================================================--]]

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufWritePost", "InsertLeave" },
  config = function()
    local lint = require("lint")

    -- Add filetype → linters here as you install them (see header).
    lint.linters_by_ft = {}

    -- Run the relevant linters whenever we save or leave insert mode.
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
