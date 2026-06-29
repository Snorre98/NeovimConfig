# Neovim Config

# TODO NOW

- https://github.com/carderne/pi-nvim

--------

My portable Neovim setup. One repo, **two configs**, switchable per-launch:

| Config       | Launch with                       | For                                   |
| ------------ | --------------------------------- | ------------------------------------- |
| **nooby**    | `nvim`                            | Getting started — clean, Zed-like     |
| **advanced** | `NVIM_APPNAME=nvim-advanced nvim` | Daily driver — git, debug, formatting |

Both share the same file layout, so once you understand one you understand both. Every config file starts with a comment block explaining *what it does, why it's here, and which keymaps it adds.*

---

## Install on a new machine

```sh
git clone <this-repo-url> ~/NeovimConfig
cd ~/NeovimConfig
bash install.sh          # symlinks both configs into ~/.config/
nvim                     # first launch auto-installs all plugins; wait for it
```

Then inside Neovim run `:checkhealth` to see what's missing, and `:Mason` to watch language servers install.

Optional shortcut for the advanced config — add to `~/.zshrc`:

```sh
alias nva='NVIM_APPNAME=nvim-advanced nvim'
```

### How the switching works

Neovim reads its config from `~/.config/$NVIM_APPNAME` (default `nvim`). `install.sh` makes two symlinks pointing back into this repo:

```
~/.config/nvim          ->  <repo>/nvim            (nooby)
~/.config/nvim-advanced ->  <repo>/nvim-advanced   (advanced)
```

So `git pull` here updates your editor on every machine. The two configs have completely separate plugins, state, and lockfiles — they can't interfere.

---

## Requirements

- **Neovim 0.11+** (uses the modern built-in LSP API).
- **git**, **ripgrep** (`rg`) — for the fuzzy finder's project search.
- A **Nerd Font** in your terminal (for icons): <https://www.nerdfonts.com>.
- Per language (only if you use it): **Node.js** (TS/JS + prettier), **Go**, **Rust** (via <https://rustup.rs>), a **JDK 17+** (Java), a C compiler (C). Language *servers* install automatically via Mason; the *toolchains* you provide.

---

## Keymap cheat sheet

`<leader>` = **Space**. Press `<Space>` and wait — **which-key** pops up showing every option. That's the intended way to learn this; the list below is just a reference.

### Both configs

| Keys                      | Action                                  |
| ------------------------- | --------------------------------------- |
| `Ctrl-p` / `<leader>ff`   | Find files                              |
| `<leader>fg`              | Search text across the project (grep)   |
| `<leader>fb`              | Switch open buffers                     |
| `<leader>fr`              | Recent files                            |
| `<leader>e`               | Toggle file tree                        |
| `Ctrl-s`                  | Save                                    |
| `Ctrl-h/j/k/l`            | Move between split windows              |
| `gd` / `gr` / `gI`        | Go to definition / references / impl    |
| `K`                       | Hover documentation                     |
| `<leader>rn`              | Rename symbol                           |
| `<leader>ca`              | Code action (quick fix)                 |
| `[d` / `]d`               | Previous / next diagnostic              |
| `gcc` / `gc` (visual)     | Toggle comment (built into Neovim)      |
| `Tab` (in popup)          | Accept completion                       |

### Advanced only (extras)

| Keys                  | Action                                  |
| --------------------- | --------------------------------------- |
| `<leader>gg`          | Open Neogit (git dashboard)             |
| `]c` / `[c`           | Next / previous git hunk                |
| `<leader>gs/gr/gp/gb` | Git: stage / reset / preview / blame    |
| `<leader>cf`          | Format buffer (also runs on save)       |
| `s`                   | Flash jump (teleport on screen)         |
| `<leader>ha` / `hh`   | Harpoon: add file / open menu           |
| `<leader>1..4`        | Jump to pinned Harpoon file             |
| `<leader>xx`          | Diagnostics list (Trouble)              |
| `<leader>db/dc/du`    | Debug: breakpoint / continue / toggle UI|
| `]t` / `[t`           | Next / previous TODO comment            |

---

## What's different between the two

The advanced config = the nooby config **plus** these extra files in `lua/plugins/`:

- `git.lua` — gitsigns + Neogit
- `format.lua` — conform.nvim, format-on-save
- `lint.lua` — nvim-lint (standalone linters)
- `java.lua` — nvim-jdtls (full Java; nooby gets syntax only)
- `rust.lua` — rustaceanvim (richer Rust)
- `debug.lua` — nvim-dap visual debugger
- `navigation.lua` — flash, harpoon, trouble
- `ui.lua` — noice, todo-comments, indent guides
- `tools.lua` — auto-installs formatters + jdtls via Mason

The advanced `lsp.lua` also drops `rust_analyzer` (rustaceanvim owns it) and Java (jdtls owns it).

---

## Customising (you'll want this)

**Add a plugin:** drop a new file in `lua/plugins/`, e.g. `lua/plugins/myplugin.lua`:

```lua
return { "author/plugin-name", opts = {} }
```

lazy.nvim auto-loads every file in that folder — no other edits needed. Run `:Lazy` to manage plugins.

**Add a language server:** add its name to the `ensure_installed` list in `lua/plugins/lsp.lua`. Find names in `:help lspconfig-all`. For per-server settings, add a `vim.lsp.config("name", { settings = {...} })` block there.

**Change the colorscheme:** edit `lua/plugins/colorscheme.lua` (instructions are in that file).

**Folder structure:**

```
init.lua                  entry point (sets leader, loads the rest)
lua/config/options.lua    editor behaviour
lua/config/keymaps.lua    custom shortcuts
lua/config/lazy.lua       plugin-manager bootstrap
lua/plugins/*.lua         one file per plugin/concern
```

---

## Troubleshooting

- **Icons look like boxes** → install + select a Nerd Font in your terminal.
- **Project search does nothing** → install ripgrep (`brew install ripgrep`).
- **A language server won't start** → `:Mason` to check it installed; `:LspInfo` to see what's attached; `:checkhealth` for details.
- **Java not working** → ensure `java -version` shows 17+, and `:MasonInstall jdtls`.
