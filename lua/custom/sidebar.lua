local state = {
  sidebar = {
    buf = -1,
    win = -1,
  },
}

local function open_sidebar()
  -- Create a vertical split on the left side
  vim.cmd 'leftabove vsplit'

  -- Get the newly created window and buffer
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()

  local width = math.floor(25)
  vim.api.nvim_win_set_width(win, width)

  -- Open oil in the sidebar if not already a open
  if vim.bo[buf].buftype ~= 'oil' then
    vim.cmd.Oil()
    -- Get the new oil buffer
    buf = vim.api.nvim_get_current_buf()
  end

  return { buf = buf, win = win }
end

local function close_sidebar()
  if vim.api.nvim_win_is_valid(state.sidebar.win) then
    vim.api.nvim_win_close(state.sidebar.win, false)
  end
end

local function toggle_sidebar()
  if state.sidebar.win ~= -1 and vim.api.nvim_win_is_valid(state.sidebar.win) then
    close_sidebar()
    state.sidebar = { buf = -1, win = -1 }
  else
    state.sidebar = open_sidebar()
  end
end

vim.keymap.set({ 'n', 't' }, '<leader>sb', toggle_sidebar)
