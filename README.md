# Rust Learning

Small Rust projects and notes for building Rust foundations with comparisons to C#.

## Modules

| Module | Focus | Project |
| --- | --- | --- |
| 0 | Toolchain and Cargo | `00-hello-cargo` |
| 1 | Syntax, functions, expressions, and control flow | `01-temperature-converter` |
| 2 | Ownership and borrowing | `02-ownership` |
| 3 | Structs, enums, and pattern matching | `03-shapes` |
| 4 | Error handling with `Result` and `?` | `04-file-reader` |

The full learning path and progress log live in [ROADMAP.md](ROADMAP.md). Short reference notes live in [RUST_CHEATSHEET.md](RUST_CHEATSHEET.md).

## Running Checks

Each numbered directory is its own Cargo package:

```sh
cargo test --manifest-path 00-hello-cargo/Cargo.toml
cargo test --manifest-path 01-temperature-converter/Cargo.toml
cargo test --manifest-path 02-ownership/Cargo.toml
cargo test --manifest-path 03-shapes/Cargo.toml
cargo test --manifest-path 04-file-reader/Cargo.toml
```

Formatting and linting:

```sh
cargo fmt --manifest-path 00-hello-cargo/Cargo.toml -- --check
cargo clippy --manifest-path 00-hello-cargo/Cargo.toml -- -D warnings
```

Repeat those commands with the other module `Cargo.toml` paths as needed.

## Neovim Setup

The `nvim/` folder contains the plugin-free Neovim config used to work through these modules. Two ways to use it:

**Try it without touching your own config** — from the repo root:

```sh
XDG_CONFIG_HOME=$(pwd) nvim
```

Neovim resolves its config as `$XDG_CONFIG_HOME/nvim/init.lua`, which is this repo's `nvim/` folder. Nothing is installed and your own setup stays untouched.

**Adopt it** — back up your existing config first, then symlink:

```sh
mv ~/.config/nvim ~/.config/nvim.bak
ln -s "$(pwd)/nvim" ~/.config/nvim
```

### What you get

- `F2` — toggle a beginner cheat sheet with basic vim survival commands
- `Space cc` / `Space cr` / `Space ct` — `cargo check` / `run` / `test` for the project the current file belongs to, in a bottom terminal split
- rust-analyzer with clippy diagnostics and format-on-save for `.rs` files
- Standard LSP keymaps: `gd` definition, `gr` references, `K` hover docs, `Space rn` rename, `Space ca` code action, `[d` / `]d` previous/next diagnostic, `Space d` diagnostic float, `Space f` format
- Sensible defaults: relative line numbers, 4-space indent, smart-case search, true color

### Prerequisites

- Neovim **0.11+** (the config uses `vim.lsp.config` / `vim.lsp.enable`)
- `rust-analyzer` on your PATH: `rustup component add rust-analyzer`
