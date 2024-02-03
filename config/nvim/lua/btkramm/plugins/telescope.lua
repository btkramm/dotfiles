return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim',
  },
  config = function()
    local lg_actions = require('telescope-live-grep-args.actions')

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
      },
      extensions = {
        file_browser = {
          preview_title = '',
          prompt_title = 'Explorer',

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
        live_grep_args = {
          preview_title = '',
          prompt_title = 'Grep',

          mappings = {
            ['i'] = {
              ['<C-q>'] = lg_actions.quote_prompt(),
            },
            ['n'] = {
              ['q'] = lg_actions.quote_prompt(),
            },
          },
        },
      },
    })

    require('telescope').load_extension('file_browser')
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('live_grep_args')
  end,
}
