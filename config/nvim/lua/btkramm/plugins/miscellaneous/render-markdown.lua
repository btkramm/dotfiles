vim.treesitter.language.register('markdown', 'octo')

return {
  'MeanderingProgrammer/render-markdown.nvim',

  opts = {
    file_types = { 'markdown', 'octo' },

    heading = { enabled = false },

    code = { enabled = false },
  },
}
