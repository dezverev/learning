# Neovim config in the repo — design

**Date:** 2026-06-10
**Goal:** Ship the Neovim setup used for this Rust-learning repo inside the repo itself, so anyone who pulls it can get the identical editor experience. The repo becomes the single source of truth for DZ's own config via a symlink.

## Background

The current config lives at `~/.config/nvim` and consists of two files, with no plugins (no plugin manager needed — fully portable):

- `init.lua` — editor options, leader keymaps, `<leader>cc/cr/ct` cargo terminal commands (find nearest `Cargo.toml`, run in a bottom split), diagnostics config, LSP keymaps on `LspAttach`, rust-analyzer setup (clippy as check command, format-on-save for `*.rs`).
- `lua/cheatsheet.lua` — F2-toggled beginner cheat-sheet popup window.

## Layout

New top-level `nvim/` folder in the repo, holding the config in the exact shape Neovim expects:

```
nvim/
├── init.lua
└── lua/
    └── cheatsheet.lua
```

## Migration (DZ's machine)

1. Copy `~/.config/nvim/init.lua` and `~/.config/nvim/lua/cheatsheet.lua` into `repo/nvim/`.
2. Move the original `~/.config/nvim` aside as a timestamped backup (e.g. `~/.config/nvim.bak-2026-06-10`); keep until verified.
3. Symlink `~/.config/nvim → /Users/dz/learning/nvim`.
4. From then on, config edits are tracked by `git status` automatically.

## README documentation

Add a "Neovim setup" section to `README.md` with:

**Two consumption paths, safest first:**
1. *Try without touching your config:* run `XDG_CONFIG_HOME=$(pwd) nvim` from the repo root. Neovim resolves its config as `$XDG_CONFIG_HOME/nvim/init.lua`, which is exactly the repo's `nvim/` folder. Zero install, zero risk to an existing setup.
2. *Adopt it:* back up any existing `~/.config/nvim`, then symlink it to the repo's `nvim/` folder.

**What you get:** F2 cheat sheet for vim beginners, `<leader>cc/cr/ct` (cargo check/run/test on the project the current file belongs to), rust-analyzer with clippy diagnostics, format-on-save, standard LSP keymaps (`gd`, `gr`, `K`, `<leader>rn`, `<leader>ca`, `[d`/`]d`).

**Prerequisites:** Neovim 0.11+ (config uses `vim.lsp.config`/`vim.lsp.enable`), `rust-analyzer` on PATH (`rustup component add rust-analyzer`).

## Error handling

- Migration keeps a backup of the original `~/.config/nvim` until verified.
- README adoption instructions tell visitors to back up their own config before symlinking.
- The config itself already degrades gracefully (cargo commands warn if no `Cargo.toml` found; LSP simply doesn't attach if rust-analyzer is missing).

## Verification

1. Headless launch (`nvim --headless +q`) exits cleanly after the symlink swap — config loads without errors.
2. DZ opens a `.rs` file in `03-shapes`, confirms rust-analyzer attaches and diagnostics appear.
3. F2 cheat sheet toggles open/closed.
4. `XDG_CONFIG_HOME=$(pwd) nvim` path works from a clean shell.

## Out of scope

- No plugins or plugin manager.
- No changes to the config content itself — this ships it as-is.
