return {
  'stevearc/oil.nvim',
  ---@module 'oil',
  ---@type oil.SetupOpts,
  opts = {
    keymaps = {
      ['<CR>'] = function()
        local oil = require 'oil'
        local entry = oil.get_cursor_entry()

        if entry then
          if entry.type == 'file' then
            -- Open files in a vertical split
            oil.select { vertical = true }
          else
            -- For directories, use default behavior (navigate into folder)
            oil.select()
          end
        end
      end,
      ['<C-l>'] = false,
    },
  },
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = false,
}
