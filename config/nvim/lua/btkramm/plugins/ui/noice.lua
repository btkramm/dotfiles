return {
  'folke/noice.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  event = 'VeryLazy',

  opts = {
    cmdline = { enabled = true, view = 'cmdline' },

    messages = { enabled = false, view = 'mini', view_error = 'mini', view_warn = 'mini' },

    notify = { enabled = false },

    lsp = {
      progress = { enabled = false },
    },

    views = {
      mini = {
        position = { row = -1, col = 0 },
        size = { width = '100%' },
        align = 'left',
      },
    },
  },
}
