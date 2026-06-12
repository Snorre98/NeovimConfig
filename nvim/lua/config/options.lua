--[[============================================================================
  config/options.lua — core editor behaviour.

  `vim.opt.X = Y` sets option X. These are the settings that make Neovim feel
  modern and Zed-like before any plugin loads. Read each comment to learn what
  the option does; tweak freely.
============================================================================--]]

local opt = vim.opt

-- ── Line numbers ───────────────────────────────────────────────────────────
opt.number = true         -- show the absolute number on the current line
opt.relativenumber = true -- show relative numbers on others (makes 5j, 3k easy)

-- ── Mouse & clipboard (the "it just works like a normal editor" bits) ────────
opt.mouse = "a"            -- enable mouse in all modes (click, scroll, select)
opt.clipboard = "unnamedplus" -- yank/paste uses the SYSTEM clipboard (cmd/ctrl+v elsewhere works)

-- ── Indentation: 2 spaces, no tabs (a common, tidy default) ──────────────────
opt.expandtab = true   -- pressing <Tab> inserts spaces
opt.shiftwidth = 2     -- size of an indent
opt.tabstop = 2        -- how wide a literal tab looks
opt.smartindent = true -- auto-indent new lines sensibly

-- ── Search ───────────────────────────────────────────────────────────────--
opt.ignorecase = true -- searching is case-insensitive…
opt.smartcase = true  -- …unless you type a capital letter
opt.hlsearch = true   -- highlight all matches (clear with <Esc>, mapped in keymaps)

-- ── Appearance ───────────────────────────────────────────────────────────--
opt.termguicolors = true -- enable 24-bit colours (needed for modern themes)
opt.signcolumn = "yes"   -- always show the left gutter so text doesn't jump
opt.cursorline = true    -- highlight the line the cursor is on
opt.scrolloff = 8        -- keep 8 lines visible above/below the cursor
opt.wrap = false         -- don't wrap long lines

-- ── Splits: open new windows where you'd expect ─────────────────────────────
opt.splitright = true -- vertical splits open to the right
opt.splitbelow = true -- horizontal splits open below

-- ── Files & undo ─────────────────────────────────────────────────────────--
opt.swapfile = false      -- no .swp files cluttering things up
opt.undofile = true       -- persist undo history to disk, even after closing
opt.updatetime = 250      -- faster response (e.g. diagnostics, CursorHold)
opt.timeoutlen = 400      -- how long to wait for a mapped key sequence (which-key)

-- ── Quality of life ─────────────────────────────────────────────────────--
opt.completeopt = "menuone,noselect" -- better completion menu behaviour
opt.confirm = true                    -- ask to save instead of erroring on :q with changes
