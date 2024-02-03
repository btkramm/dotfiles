return {
  'cbochs/grapple.nvim',

  opts = {
    icons = false,

    win_opts = { border = 'rounded', footer = '' },
  },

  keys = {
    {
      '§',
      function()
        require('grapple').tag()
      end,
      desc = 'Grapple - Add',
    },
    {
      '<C-D-M-S-h>',
      function()
        require('grapple').select({ index = 1 })
      end,
      desc = 'Grapple - Select "h"',
    },
    {
      '<C-D-M-S-j>',
      function()
        require('grapple').select({ index = 2 })
      end,
      desc = 'Grapple - Select "j"',
    },
    {
      '<C-D-M-S-k>',
      function()
        require('grapple').select({ index = 3 })
      end,
      desc = 'Grapple - Select "k"',
    },
    {
      '<C-D-M-S-l>',
      function()
        require('grapple').select({ index = 4 })
      end,
      desc = 'Grapple - Select "l"',
    },
    {
      '<D-i>',
      function()
        require('grapple').toggle_tags()
      end,
      desc = 'Grapple - Toggle',
    },
  },
}
