return {
  'nvim-treesitter/nvim-treesitter',
  dependencies = {
    {
      'nvim-treesitter/nvim-treesitter-context',

      opts = { max_lines = 2 },
    },
  },
  branch = 'main',
  build = ':TSUpdate',
  lazy = false,

  config = function()
    require('nvim-treesitter').install('all')

    vim.api.nvim_create_autocmd('FileType', {
      group = vim.api.nvim_create_augroup('treesitter', { clear = true }),
      callback = function(e)
        if not pcall(vim.treesitter.start, e.buf) then
          return
        end

        local language = vim.treesitter.language.get_lang(vim.bo[e.buf].filetype)

        -- Without an indents query, the indentexpr of Vim is better.
        if language and vim.treesitter.query.get(language, 'indents') then
          vim.bo[e.buf].indentexpr = [[v:lua.require'nvim-treesitter'.indentexpr()]]
        end
      end,
    })
  end,
}
