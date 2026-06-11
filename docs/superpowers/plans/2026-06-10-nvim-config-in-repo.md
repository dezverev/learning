# Neovim Config in the Repo — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Ship the Neovim config inside the repo (`nvim/` folder), make it DZ's live config via symlink, and document setup for visitors in the README.

**Architecture:** A top-level `nvim/` folder holds the config in the exact directory shape Neovim expects (`init.lua` + `lua/cheatsheet.lua`), so it works directly as a config root via `XDG_CONFIG_HOME` or a symlink. No plugins, no plugin manager — the two files are self-contained.

**Tech Stack:** Neovim 0.11+ Lua config, rust-analyzer LSP, git.

**Spec:** `docs/superpowers/specs/2026-06-10-nvim-config-in-repo-design.md`

---

### Task 1: Add the config files to the repo

**Files:**
- Create: `nvim/init.lua`
- Create: `nvim/lua/cheatsheet.lua`

- [ ] **Step 1: Create `nvim/init.lua`** with exactly this content (identical to the current `~/.config/nvim/init.lua`):

```lua
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 250

vim.keymap.set("n", "<leader>e", vim.cmd.Ex, { desc = "Open file browser" })
vim.keymap.set("n", "<leader>w", vim.cmd.write, { desc = "Save file" })
vim.keymap.set("n", "<leader>q", vim.cmd.quit, { desc = "Quit window" })
vim.keymap.set("n", "<Esc>", vim.cmd.nohlsearch, { desc = "Clear search highlight" })

for _, mode in ipairs({ "n", "i", "v", "x", "o", "c", "t" }) do
  vim.keymap.set(mode, "<F1>", "<Nop>", { silent = true, desc = "Disable built-in help key" })
end

vim.keymap.set("n", "<F2>", require("cheatsheet").toggle, { desc = "Toggle cheat sheet" })
vim.keymap.set("i", "<F2>", function()
  vim.cmd.stopinsert()
  require("cheatsheet").toggle()
end, { desc = "Toggle cheat sheet" })

local function cargo_command(args)
  local file = vim.api.nvim_buf_get_name(0)
  local start_dir = file ~= "" and vim.fs.dirname(file) or vim.uv.cwd()
  local cargo_toml = vim.fs.find("Cargo.toml", { path = start_dir, upward = true })[1]

  if cargo_toml == nil then
    vim.notify("No Cargo.toml found for this file", vim.log.levels.WARN)
    return
  end

  local project_dir = vim.fs.dirname(cargo_toml)
  vim.cmd("botright split")
  vim.cmd("resize 12")
  vim.cmd("terminal cd " .. vim.fn.shellescape(project_dir) .. " && cargo " .. args)
  vim.cmd("startinsert")
end

vim.keymap.set("n", "<leader>cc", function()
  cargo_command("check")
end, { desc = "Cargo check" })

vim.keymap.set("n", "<leader>cr", function()
  cargo_command("run")
end, { desc = "Cargo run" })

vim.keymap.set("n", "<leader>ct", function()
  cargo_command("test")
end, { desc = "Cargo test" })

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(event)
    local map = function(keys, action, desc)
      vim.keymap.set("n", keys, action, { buffer = event.buf, desc = desc })
    end

    map("gd", vim.lsp.buf.definition, "Go to definition")
    map("gr", vim.lsp.buf.references, "Show references")
    map("K", vim.lsp.buf.hover, "Show documentation")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action")
    map("<leader>f", function()
      vim.lsp.buf.format({ async = true })
    end, "Format file")
    map("[d", vim.diagnostic.goto_prev, "Previous diagnostic")
    map("]d", vim.diagnostic.goto_next, "Next diagnostic")
    map("<leader>d", vim.diagnostic.open_float, "Show diagnostic")
  end,
})

vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", ".git" },
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      check = {
        command = "clippy",
      },
    },
  },
})

vim.lsp.enable("rust_analyzer")

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})
```

- [ ] **Step 2: Create `nvim/lua/cheatsheet.lua`** with exactly this content (identical to the current `~/.config/nvim/lua/cheatsheet.lua`):

```lua
local M = {}

local win_id = nil

local lines = {
  " HELP                                                            F2 opens/closes this",
  "",
  " GET READY     Esc = stop typing / go back to command mode",
  "",
  " MOVE          h left     j down     k up       l right",
  " MOVE WORDS    w next word           b previous word",
  " MOVE FILE     gg top                G bottom",
  "",
  " TYPE          i start typing        Esc stop typing",
  " EDIT          x delete letter       dd delete line",
  " EDIT          u undo                Ctrl-r redo",
  " COPY/PASTE    yy copy line          p paste",
  "",
  " SAVE          :w then Enter",
  " QUIT          :q then Enter",
  " SAVE+QUIT     :wq then Enter",
  " FORCE QUIT    :q! then Enter",
  "",
  " If stuck: press Esc, type :qa!, press Enter",
}

local function close()
  if win_id ~= nil and vim.api.nvim_win_is_valid(win_id) then
    vim.api.nvim_win_close(win_id, true)
  end
  win_id = nil
end

function M.toggle()
  if win_id ~= nil and vim.api.nvim_win_is_valid(win_id) then
    close()
    return
  end

  local buf_id = vim.api.nvim_create_buf(false, true)
  vim.bo[buf_id].buftype = "nofile"
  vim.bo[buf_id].bufhidden = "wipe"
  vim.bo[buf_id].swapfile = false
  vim.bo[buf_id].filetype = "nvim-cheatsheet"

  vim.bo[buf_id].modifiable = true
  vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
  vim.bo[buf_id].modifiable = false

  vim.cmd("botright split")
  win_id = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win_id, buf_id)
  vim.api.nvim_win_set_height(win_id, #lines)

  vim.wo[win_id].number = false
  vim.wo[win_id].relativenumber = false
  vim.wo[win_id].signcolumn = "no"
  vim.wo[win_id].cursorline = false
  vim.wo[win_id].foldcolumn = "0"
  vim.wo[win_id].wrap = false

  vim.keymap.set("n", "q", close, { buffer = buf_id, silent = true, desc = "Close cheat sheet" })
  vim.keymap.set("n", "<F2>", close, { buffer = buf_id, silent = true, desc = "Close cheat sheet" })
end

return M
```

- [ ] **Step 3: Verify the repo copy matches the live config byte-for-byte**

Run: `diff -r ~/.config/nvim /Users/dz/learning/nvim && echo IDENTICAL`
Expected: `IDENTICAL` (no diff output)

- [ ] **Step 4: Verify the repo copy loads cleanly as a config root** (tests the visitor path before touching the live config)

Run: `cd /Users/dz/learning && XDG_CONFIG_HOME=$(pwd) nvim --headless +q; echo "exit: $?"`
Expected: no error output, `exit: 0`

- [ ] **Step 5: Commit**

```bash
cd /Users/dz/learning
git add nvim/
git commit -m "Add Neovim config to the repo

Plugin-free setup: cargo check/run/test keymaps, rust-analyzer with
clippy + format-on-save, F2 beginner cheat sheet.

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 2: Document setup in the README

**Files:**
- Modify: `README.md` (append after the "Running Checks" section, line 34)

- [ ] **Step 1: Append this section to the end of `README.md`** (after the final line "Repeat those commands with the other module `Cargo.toml` paths as needed."):

````markdown

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
````

- [ ] **Step 2: Verify the README references match reality**

Run: `grep -c 'nvim' /Users/dz/learning/README.md && ls /Users/dz/learning/nvim/init.lua`
Expected: a count ≥ 5 and the `init.lua` path printed (folder name in docs matches folder on disk)

- [ ] **Step 3: Commit**

```bash
cd /Users/dz/learning
git add README.md
git commit -m "Document Neovim setup in README

Co-Authored-By: Claude Fable 5 <noreply@anthropic.com>"
```

---

### Task 3: Make the repo the live config (DZ's machine)

**Files:** none in the repo — local filesystem only.

- [ ] **Step 1: Back up the current config** (timestamped, kept until verified)

```bash
mv ~/.config/nvim ~/.config/nvim.bak-2026-06-10
```

- [ ] **Step 2: Symlink the repo config into place**

```bash
ln -s /Users/dz/learning/nvim ~/.config/nvim
```

- [ ] **Step 3: Verify the symlink and that Neovim loads cleanly through it**

Run: `readlink ~/.config/nvim && nvim --headless +q; echo "exit: $?"`
Expected: `/Users/dz/learning/nvim`, no error output, `exit: 0`

---

### Task 4: End-to-end verification

- [ ] **Step 1: Confirm git tracking works through the symlink** — touch nothing, just confirm a clean state

Run: `cd /Users/dz/learning && git status --porcelain; echo "exit: $?"`
Expected: no output (clean tree), `exit: 0`

- [ ] **Step 2: Manual checks (DZ, in a terminal)** — these need an interactive session, so report them as a checklist for DZ rather than automating:

1. `nvim 03-shapes/src/main.rs` — rust-analyzer attaches (`:LspInfo` shows `rust_analyzer` attached; diagnostics appear if you introduce a typo)
2. `F2` toggles the cheat sheet open and closed
3. `Space cc` opens a bottom split running `cargo check` for `03-shapes`
4. Backup can be deleted afterwards: `rm -rf ~/.config/nvim.bak-2026-06-10`
