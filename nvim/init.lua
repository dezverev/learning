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
