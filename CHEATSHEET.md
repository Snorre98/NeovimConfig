# Neovim Cheat Sheet

> New to Vim? The whole game is **modes**. You usually aren't typing — you're in
> **Normal** mode where letters are commands. **When in doubt, press `Esc`** to
> get back to Normal mode, safe.

## The 3 modes

| Mode       | For                          | Enter with        |
| ---------- | ---------------------------- | ----------------- |
| **Normal** | Moving + commands (you live here) | `Esc` (always returns here) |
| **Insert** | Typing text                  | `i`               |
| **Visual** | Selecting text               | `v`               |

## Get in, type, get out

| Key   | Action                              |
| ----- | ----------------------------------- |
| `i`   | insert before cursor (start typing) |
| `a`   | insert after cursor                 |
| `o`   | open a new line below and type      |
| `Esc` | stop typing, back to Normal         |

## Move (Normal mode)

| Key     | Action                  |
| ------- | ----------------------- |
| `h j k l` | ← ↓ ↑ → (arrows/mouse also work) |
| `w` / `b` | next / previous word    |
| `0` / `$` | start / end of line     |
| `gg` / `G`| top / bottom of file    |
| `{` / `}` | paragraph up / down     |

## Edit — verbs + motions (the magic)

Vim is a tiny language: **operator + motion**. `d`+`w` = delete word. `c`+`$` = change to end of line.

| Key      | Action                                   |
| -------- | ---------------------------------------- |
| `x`      | delete one character                     |
| `dd`     | delete whole line                        |
| `dw`     | delete a word                            |
| `cw`     | change a word (delete + start typing)    |
| `yy`     | yank (copy) a line                       |
| `p`      | paste after cursor                       |
| `u`      | **UNDO** (your best friend)              |
| `Ctrl-r` | redo                                     |

## Visual mode (select, then act)

| Key  | Action                          |
| ---- | ------------------------------- |
| `v`  | start selecting (extend w/ hjkl/w) |
| `V`  | select whole lines              |
| `y`  | copy selection                  |
| `d`  | delete selection                |
| `gc` | comment / uncomment selection   |

## Save & quit (`:` opens a command line)

| Key   | Action                          |
| ----- | ------------------------------- |
| `:w`  | save (or `Ctrl-s`)              |
| `:q`  | quit                            |
| `:wq` | save and quit                   |
| `:q!` | quit, **discard** changes (escape hatch) |
| `ZZ`  | save and quit (no colon)        |

---

## This config's shortcuts — `<leader>` = `Space`

**You don't need to memorize these — press `Space` and which-key shows you.**

### Both configs

| Keys                    | Action                              |
| ----------------------- | ----------------------------------- |
| `Ctrl-p` / `Space f f`  | Find files                          |
| `Space f g`             | Search text across the project      |
| `Space f b`             | Switch open buffers                 |
| `Space f r`             | Recent files                        |
| `Space e`               | Toggle file tree                    |
| `Ctrl-s`                | Save                                |
| `Ctrl-h/j/k/l`          | Move between split windows          |
| `gd` / `gr` / `gI`      | Go to definition / references / impl |
| `K`                     | Hover documentation                 |
| `Space r n`             | Rename symbol                       |
| `Space c a`             | Code action (quick fix)             |
| `[d` / `]d`             | Previous / next diagnostic          |
| `gcc` / `gc` (visual)   | Toggle comment                      |
| `Tab` (in popup)        | Accept completion                   |

### Advanced config only

| Keys                  | Action                               |
| --------------------- | ------------------------------------ |
| `Space g g`           | Open Neogit (git dashboard)          |
| `]c` / `[c`           | Next / previous git change           |
| `Space g s/r/p/b`     | Git: stage / reset / preview / blame |
| `Space c f`           | Format buffer (also runs on save)    |
| `s`                   | Flash jump (teleport on screen)      |
| `Space h a` / `h h`   | Harpoon: add file / open menu        |
| `Space 1..4`          | Jump to pinned Harpoon file          |
| `Space x x`           | Diagnostics list (Trouble)           |
| `Space d b/c/u`       | Debug: breakpoint / continue / UI    |
| `]t` / `[t`           | Next / previous TODO comment         |

---

## First-week plan

1. **Day 1–2:** Use only `i` `Esc` `hjkl` `x` `dd` `u` `:w` `:q`. Arrows/mouse OK for the rest. Just survive.
2. **Day 3+:** Add `w`/`b`, `cw`, `dw`, `yy`/`p`, `Ctrl-p`. This is where it gets fast.
3. **When curious:** run `:Tutor` — Neovim's excellent built-in 30-min interactive lesson.

**Safety nets:** `Esc` then `u` undoes anything. `Esc` then `:q!` bails out without saving.
