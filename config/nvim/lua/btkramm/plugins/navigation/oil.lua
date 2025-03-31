return {
  'stevearc/oil.nvim',
  lazy = false,

  opts = {
    default_file_explorer = false,

    skip_confirm_for_simple_edits = true,

    lsp_file_methods = { enabled = true, timeout_ms = 2000, autosave_changes = true },

    watch_for_changes = true,

    keymaps = {
      ['<CR>'] = 'actions.select',

      ['h'] = 'actions.parent',
      ['l'] = 'actions.select',

      ['<C-x>'] = {
        'actions.select',
        opts = { horizontal = true, split = 'belowright' },
      },
      ['<C-v>'] = {
        'actions.select',
        opts = { vertical = true, split = 'belowright' },
      },

      ['<C-p>'] = 'actions.preview',

      ['<Esc>'] = 'actions.close',
      ['q'] = 'actions.close',

      ['<C-.>'] = 'actions.toggle_hidden',
      ['<C\\>'] = 'actions.toggle_trash',

      [',v'] = '<NOP>',
      [',x'] = '<NOP>',
    },

    use_default_keymaps = false,

    float = {
      preview_split = 'right',
    },
  },

  keys = {
    {
      '<D-S-e>',
      function()
        if vim.bo.filetype ~= 'oil' then
          require('oil').open_float()
        end
      end,
      desc = 'Oil - Open',
    },
    {
      '<D-e>',
      function()
        if vim.bo.filetype ~= 'oil' then
          require('oil').open_float(vim.fn.getcwd())
        end
      end,
      desc = 'Oil - Open at CWD',
    },
  },
}
