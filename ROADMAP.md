# Learning Rust — Roadmap

A project-based path to solid Rust foundations, taught by contrast with C#.

**Toolchain:** rustc/cargo 1.94.0 via rustup. Run `rustup update` occasionally.

## Legend
- [ ] not started  ·  [~] in progress  ·  [x] done

## Modules

| # | Module | Focus (vs C#) | Mini-project | Status |
|---|--------|---------------|--------------|--------|
| 0 | Toolchain & Cargo | `dotnet` CLI → `cargo` | `00-hello-cargo` | [x] |
| 1 | Syntax & control flow | everything is an *expression*; `let`/`mut`/shadowing | `01-temperature-converter` | [x] |
| 2 | Ownership & borrowing | replaces the GC | string/slice drills | [x] |
| 3 | Structs, enums, pattern matching | sum types + `match`; `Option` kills `null` | shapes model | [~] |
| 4 | Error handling | `Result`/`?` replace exceptions | file-reading tool | [ ] |
| 5 | Generics & traits | traits ≈ interfaces, no inheritance | generic + trait design | [ ] |
| 6 | Collections, iterators, closures | lazy, zero-cost LINQ | data-processing pipeline | [ ] |
| 7 | Modules, crates, dependencies | `using`/NuGet → `mod`/crates.io | pull in a crate | [ ] |
| 8 | Lifetimes & smart pointers | `Box`/`Rc`/`RefCell` | — | [ ] |
| 9 | Testing + capstone | `xUnit` → built-in `#[test]` | a real CLI tool | [ ] |

_Later, by interest: concurrency & fearless threading → async/`tokio`._

## Session loop
1. **Concept** — short, framed against C#.
2. **We write code** — in a real `cargo` project.
3. **Compiler-driven learning** — deliberately trigger errors, read them.
4. **Your turn** — a small challenge.
5. **Milestone** — finish the mini-project, tick it here.

## Progress log
<!-- newest first -->
- **2026-06-08** — ✅ Module 2 done: `02-ownership` drills. Covered move semantics (`Copy` vs not), double-free reasoning, `clone`, borrowing (`&`/`&mut`), shared-XOR-mutable rule, NLL (DZ re-derived it!), slices/`&str`, borrow checker preventing use-after-free (≈ C# "Collection was modified"). DZ nailed the borrow choices. Next: Module 3 (structs/enums/match).
- **2026-06-08** — ✅ Module 1 done: `01-temperature-converter` (C↔F, round-trip, table). Covered `let`/`mut`/shadowing (+type change), `f64` vs integer division, functions w/ mandatory signatures, expression-based returns, arrays, `for`/ranges, `if`-as-expression, control-flow roundup. Clippy clean. Next: Module 2 (ownership).
- **2026-06-06** — ✅ Module 0 done: `00-hello-cargo` builds/runs. Covered cargo vs dotnet, Cargo.toml, editions, macros (`!`), debug/release, `check`/`clippy`/`fmt`, target/lockfile. Starting Module 1.
- **2026-06-06** — Repo + tracker set up. Toolchain verified (1.94.0). Starting Module 0.
