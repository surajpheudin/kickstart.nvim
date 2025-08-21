local state = {
  sidebar = {
    win = -1,
  },
}

local function open_sidebar()
  -- Create a vertical split on the left side
  vim.cmd 'leftabove vsplit'
  vim.cmd.Oil()

  local width = math.floor(25)
  local win = vim.api.nvim_get_current_win()

  vim.api.nvim_win_set_width(win, width)
  vim.api.nvim_set_option_value('winfixwidth', true, { win = win })

  return { win = win }
end

local function close_sidebar()
  if vim.api.nvim_win_is_valid(state.sidebar.win) then
    vim.api.nvim_win_close(state.sidebar.win, false)
  end
end

local function toggle_sidebar()
  if vim.api.nvim_win_is_valid(state.sidebar.win) then
    close_sidebar()
    state.sidebar = { buf = -1, win = -1 }
  else
    state.sidebar = open_sidebar()
  end
end

vim.keymap.set({ 'n', 't' }, '<leader>sb', toggle_sidebar)
