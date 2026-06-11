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
