# Rust Learning

Small Rust projects and notes for building Rust foundations with comparisons to C#.

## Modules

| Module | Focus | Project |
| --- | --- | --- |
| 0 | Toolchain and Cargo | `00-hello-cargo` |
| 1 | Syntax, functions, expressions, and control flow | `01-temperature-converter` |
| 2 | Ownership and borrowing | `02-ownership` |
| 3 | Structs, enums, and pattern matching | `03-shapes` |

The full learning path and progress log live in [ROADMAP.md](ROADMAP.md). Short reference notes live in [RUST_CHEATSHEET.md](RUST_CHEATSHEET.md).

## Running Checks

Each numbered directory is its own Cargo package:

```sh
cargo test --manifest-path 00-hello-cargo/Cargo.toml
cargo test --manifest-path 01-temperature-converter/Cargo.toml
cargo test --manifest-path 02-ownership/Cargo.toml
cargo test --manifest-path 03-shapes/Cargo.toml
```

Formatting and linting:

```sh
cargo fmt --manifest-path 00-hello-cargo/Cargo.toml -- --check
cargo clippy --manifest-path 00-hello-cargo/Cargo.toml -- -D warnings
```

Repeat those commands with the other module `Cargo.toml` paths as needed.
