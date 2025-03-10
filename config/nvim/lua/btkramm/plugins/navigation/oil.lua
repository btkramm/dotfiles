return {
  'stevearc/oil.nvim',
  lazy = false,

  opts = {
    default_file_explorer = true,

    skip_confirm_for_simple_edits = true,

    lsp_file_methods = { enabled = true, timeout_ms = 2000, autosave_changes = true },

    watch_for_changes = true,

    keymaps = {
      ['<CR>'] = 'actions.select',

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

      ['-'] = 'actions.parent',
      ['_'] = 'actions.open_cwd',

      ['<C-.>'] = 'actions.toggle_hidden',
      ['<C\\>'] = 'actions.toggle_trash',
    },

    use_default_keymaps = false,
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
