local state = {
  sidebar = {
    buf = -1,
    win = -1,
  },
}

local function open_sidebar_terminal(opts)
  local buf = nil

  if vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
  end

  vim.cmd 'vsplit'
  vim.api.nvim_win_set_buf(0, buf)

  -- Open terminal in the sidebar if not already a open
  if vim.bo[buf].buftype ~= 'terminal' then
    vim.cmd 'term'
  end

  local win = vim.api.nvim_get_current_win()

  return { buf = buf, win = win }
end

local function toggle_sidebar_terminal()
  if vim.api.nvim_win_is_valid(state.sidebar.win) then
    vim.api.nvim_win_hide(state.sidebar.win)
  else
    state.sidebar = open_sidebar_terminal { buf = state.sidebar.buf }
  end
end

vim.keymap.set({ 'n' }, '<leader>st', toggle_sidebar_terminal)
