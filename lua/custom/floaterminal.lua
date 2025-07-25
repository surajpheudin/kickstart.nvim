local state = {
	floating = {
		buf = -1,
		win = -1
	}
}

local function open_floating_window(opts)
	local ui = vim.api.nvim_list_uis()[1]

	local width = math.floor(ui.width * 0.8)
	local height = math.floor(ui.height * 0.8)
	local col = math.floor((ui.width - width)/2)
	local row = math.floor((ui.height- height)/2)

	local buf = nil

	if vim.api.nvim_buf_is_valid(opts.buf) then
		buf = opts.buf
	else
		buf = vim.api.nvim_create_buf(false, true)
	end

	local win_opts = {
		style = "minimal",
		relative = "editor",
		width = width,
		height=height,
		col = col,
		row= row,
		border = "rounded"
	}


	local win = vim.api.nvim_open_win(buf, true, win_opts)

	return { buf = buf, win = win}
end

local function toogle_floating_window()
	if vim.api.nvim_win_is_valid(state.floating.win) then
		vim.api.nvim_win_hide(state.floating.win)
	else
		state.floating = open_floating_window({buf = state.floating.buf})
		if vim.bo[state.floating.buf].buftype ~= "terminal" then
			vim.cmd.term()
		end
	end
end

vim.keymap.set({'n', 't'}, "<leader>tt", toogle_floating_window)
