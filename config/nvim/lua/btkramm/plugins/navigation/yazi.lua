return {
  'mikavilpas/yazi.nvim',
  dependencies = {
    { 'nvim-lua/plenary.nvim' },
  },

  opts = {
    floating_window_scaling_factor = 0.75,
    yazi_floating_window_border = 'none',

    keymaps = {
      grep_in_directory = '<D-g>',
    },

    integrations = {
      grep_in_directory = 'fzf-lua',
      grep_in_selected_files = 'fzf-lua',
    },
  },

  keys = {
    {
      '<D-e>',
      function()
        require('yazi').yazi()
      end,
      desc = 'Yazi - Open',
    },
    {
      '<D-S-e>',
      function()
        require('yazi').yazi(nil, vim.fn.getcwd())
      end,
      desc = 'Yazi - Open at CWD',
    },
  },
}
