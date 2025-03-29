return {
  'folke/zen-mode.nvim',

  opts = {
    plugins = {
      kitty = { enabled = true, font = '+4' },
    },
  },

  keys = {
    {
      '<leader>z',
      function()
        vim.cmd('ZenMode')

        -- https://github.com/folke/zen-mode.nvim/pull/170
        vim.cmd(':set fillchars+=vert:│')
      end,
      desc = 'ZenMode - Toggle',
    },
  },
}
