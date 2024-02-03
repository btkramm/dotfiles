return {
  'folke/zen-mode.nvim',

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
