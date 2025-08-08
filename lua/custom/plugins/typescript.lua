return {
  'pmizio/typescript-tools.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  opts = {
    on_attach = function(_, bufnr)
      local opts = { buffer = bufnr, silent = true }

      -- Organize imports
      vim.keymap.set('n', '<leader>oi', '<cmd>TSToolsOrganizeImports<CR>', opts)
    end,
  },
}

