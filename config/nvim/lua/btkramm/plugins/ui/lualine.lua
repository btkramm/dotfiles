vim.opt.laststatus = 3

local fugitive_extension = {
  sections = {
    lualine_a = {
      function()
        return '' .. ' ' .. vim.fn.FugitiveHead()
      end,
    },
    lualine_z = { 'location' },
  },

  filetypes = { 'fugitive', 'git', 'gitcommit' },
}

return {
  'nvim-lualine/lualine.nvim',

  opts = {
    sections = {
      lualine_a = { 'FugitiveHead' },
      lualine_b = { 'diff', 'diagnostics' },
      lualine_c = {
        { 'filename', path = 1 },
      },
      lualine_x = {},
      lualine_y = { 'location' },
      lualine_z = {
        {
          function()
            return require('grapple').name_or_index()
          end,
          cond = function()
            return package.loaded['grapple'] and require('grapple').exists()
          end,
        },
      },
    },

    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = { 'filename' },
      lualine_x = {},
      lualine_y = { 'location' },
      lualine_z = {},
    },

    options = { section_separators = '', component_separators = '' },

    extensions = { fugitive_extension, 'quickfix' },
  },
}
