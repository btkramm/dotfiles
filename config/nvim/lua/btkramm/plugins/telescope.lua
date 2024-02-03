return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    local actions = require('telescope.actions')

    require('telescope').setup({
      defaults = {
        results_title = '',
      },
      pickers = {
        buffers = {
          preview_title = '',
          prompt_title = 'Open Files',
        },
        find_files = {
          preview_title = '',
          prompt_title = 'Files',

          hidden = true,
        },
        git_bcommits = {
          preview_title = '',
          prompt_title = 'Buffer Git Commits',
        },
        git_branches = {
          preview_title = '',
          prompt_title = 'Git Branches',

          show_remote_tracking_branches = false,
        },
        git_commits = {
          preview_title = '',
          prompt_title = 'Git Commits',
        },
        grep_string = {
          preview_title = '',
          prompt_title = 'Grep String',
        },
        live_grep = {
          preview_title = '',
          prompt_title = 'Grep',

          additional_args = function()
            return { '--hidden' }
          end,
        },
        marks = {
          preview_title = '',
          prompt_title = 'Marks',
        },
      },
      extensions = {
        file_browser = {
          preview_title = '',
          prompt_title = 'Explorer',

          mappings = {
            ['i'] = {
              ['<A-c>'] = false,
              ['<A-d>'] = false,
              ['<A-m>'] = false,
              ['<A-r>'] = false,
              ['<A-y>'] = false,
              ['<C-e>'] = false,
              ['<C-f>'] = false,
              ['<C-g>'] = false,
              ['<C-h>'] = false,
              ['<C-o>'] = false,
              ['<C-s>'] = false,
              ['<C-t>'] = false,
              ['<C-w>'] = false,
            },
            ['n'] = {
              ['o'] = actions.select_default,
            },
          },

          hidden = {
            file_browser = true,
            folder_browser = true,
          },
        },
        fzf = {
          case_mode = 'smart_case',
          fuzzy = true,
          override_file_sorter = true,
          override_generic_sorter = true,
        },
      },
    })

    require('telescope').load_extension('file_browser')
    require('telescope').load_extension('fzf')
  end,
}
