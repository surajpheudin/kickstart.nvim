-- A state table to hold multiple terminal instances, indexed by a unique key.
local instances = {}

-- @param opts table: { buf: number, width: number, height: number }
-- `width` and `height` are scale factors (0 to 1.0)
local function open_floating_window(opts)
  opts = opts or {}
  local ui = vim.api.nvim_list_uis()[1]

  local width_scale = opts.width or 0.8
  local height_scale = opts.height or 0.8

  local width = math.floor(ui.width * width_scale)
  local height = math.floor(ui.height * height_scale)
  local col = math.floor((ui.width - width) / 2)
  local row = math.floor((ui.height - height) / 2)

  local buf
  if opts.buf and vim.api.nvim_buf_is_valid(opts.buf) then
    buf = opts.buf
  else
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, 'bufhidden', 'hide')
  end

  local win_opts = {
    style = 'minimal',
    relative = 'editor',
    width = width,
    height = height,
    col = col,
    row = row,
    border = 'rounded',
  }

  local win = vim.api.nvim_open_win(buf, true, win_opts)
  return { buf = buf, win = win }
end

-- Toggles a terminal window identified by a unique key.
-- Each key gets its own persistent terminal instance.
-- @param key string: A unique identifier for the terminal instance.
-- @param config table: { cmd: string, width: number, height: number }
local function toggle_terminal(key, config)
  config = config or {}

  -- Initialize instance state if it doesn't exist
  if not instances[key] then
    instances[key] = { buf = -1, win = -1 }
  end

  local instance = instances[key]

  if vim.api.nvim_win_is_valid(instance.win) then
    vim.api.nvim_win_close(instance.win, false)
  else
    local new_instance = open_floating_window {
      buf = instance.buf,
      width = config.width,
      height = config.height,
    }
    instances[key] = new_instance -- Update state with new win/buf info

    -- Open a terminal in the buffer if it's not already a terminal
    if vim.bo[new_instance.buf].buftype ~= 'terminal' then
      vim.api.nvim_set_current_win(new_instance.win)
      local term_cmd = config.cmd or 'term'
      vim.cmd(term_cmd)
    else
      vim.api.nvim_set_current_win(new_instance.win)
    end
  end
end

--[[
EXAMPLES
- Define your terminal configurations here.
- The key of the table is the keymap, e.g., '<leader>t1'.
- `cmd` is the command to run (e.g., 'term', 'term bash', 'term btm').
- `width` and `height` are scaling factors for the window size (0.0 to 1.0).
]]
local terminal_configs = {
  ['<leader>tt'] = { cmd = 'term', width = 0.8, height = 0.8 },
  ['<leader>tg'] = { cmd = 'term lazygit', width = 1, height = 1 },
}

-- Create keymaps for each configuration
for key, config in pairs(terminal_configs) do
  vim.keymap.set({ 'n', 't' }, key, function()
    toggle_terminal(key, config)
  end, { desc = 'Toggle floating terminal (' .. key .. ')' })
end
