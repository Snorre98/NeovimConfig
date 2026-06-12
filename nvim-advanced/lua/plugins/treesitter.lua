--[[============================================================================
  plugins/treesitter.lua — nvim-treesitter, smart syntax.

  WHAT: Treesitter parses your code into a real syntax tree. That powers
  accurate, fast highlighting and correct auto-indentation — far better than
  the old regex highlighting. This is what makes code look "right".

  `ensure_installed` lists the language parsers to download. `auto_install`
  grabs any others on demand when you open a new filetype.

  `main = "nvim-treesitter.configs"` tells lazy.nvim to run
  require("nvim-treesitter.configs").setup(opts) with the table below.
  `build = ":TSUpdate"` compiles/updates parsers after install.
============================================================================--]]

return {
  "nvim-treesitter/nvim-treesitter",
  -- Pin the stable "master" branch. (The newer "main" branch has a different,
  -- still-changing API; master is rock-solid and matches the setup below.)
  branch = "master",
  build = ":TSUpdate",
  main = "nvim-treesitter.configs",
  opts = {
    ensure_installed = {
      -- config / docs
      "lua", "luadoc", "vim", "vimdoc", "query", "bash", "markdown", "markdown_inline",
      -- web
      "javascript", "typescript", "tsx", "html", "css", "json", "jsonc",
      -- the rest of your languages
      "python", "go", "gomod", "gosum", "rust", "c", "java", "yaml", "toml",
    },
    auto_install = true,
    highlight = { enable = true },
    indent = { enable = true },
  },
}
