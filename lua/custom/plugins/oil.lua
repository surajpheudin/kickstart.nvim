return {
  'stevearc/oil.nvim',
  ---@module 'oil',
  ---@type oil.SetupOpts,
  opts = {
    keymaps = {
      ['<C-l>'] = false,
    },
  },
  dependencies = { { 'echasnovski/mini.icons', opts = {} } },
  lazy = false,
}
