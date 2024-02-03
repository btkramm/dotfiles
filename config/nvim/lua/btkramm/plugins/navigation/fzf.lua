return {
  'ibhagwan/fzf-lua',

  config = function()
    local fzf = require('fzf-lua')

    fzf.setup({
      defaults = {
        prompt = '> ',

        file_icons = false,
        git_icons = false,

        no_header = true,
        no_header_i = true,
      },

      keymap = {
        builtin = {
          true,

          ['<C-d>'] = 'preview-page-down',
          ['<C-u>'] = 'preview-page-up',
        },
        fzf = {
          true,

          ['ctrl-d'] = 'preview-page-down',
          ['ctrl-u'] = 'preview-page-up',

          ['ctrl-q'] = 'select-all+accept',
        },
      },

      actions = {
        files = {
          ['enter'] = fzf.actions.file_edit_or_qf,

          ['ctrl-v'] = fzf.actions.file_vsplit,
          ['ctrl-x'] = fzf.actions.file_split,

          ['alt-q'] = fzf.actions.file_sel_to_qf,

          ['alt-.'] = fzf.actions.toggle_hidden,
          ['alt-f'] = fzf.actions.toggle_follow,
          ['alt-i'] = fzf.actions.toggle_ignore,
        },
      },

      files = {
        cwd_prompt = false,

        hidden = false,
        follow = false,
        no_ignore = false,
      },

      git = {
        branches = {
          cmd = 'git br --color --format="%(if)%(HEAD)%(then)* %(color:green)%(else)  %(if)%(worktreepath)%(then)%(color:cyan)%(else)%(color:white)%(end)%(end)%(refname:short)%(color:reset)"',

          actions = {
            ['ctrl-x'] = false,
            ['ctrl-d'] = { fn = fzf.actions.git_branch_del, reload = true },
          },

          cmd_add = { 'git', 'checkout', '-b' },
          cmd_del = { 'git', 'branch', '--delete', '--force' },
        },

        commits = {
          actions = {
            ['enter'] = function(selected)
              local commit = selected[1]:match('[^ ]+')

              vim.fn.setreg('+', commit)
            end,
          },
        },

        bcommits = {
          actions = {
            ['enter'] = function(selected)
              local commit = selected[1]:match('[^ ]+')

              vim.fn.setreg('+', commit)
            end,
          },
        },
      },

      grep = {
        rg_glob = true,
        rg_glob_fn = function(value, _)
          local pattern, options = value:match('(.-)%s%-%-(.*)')

          return pattern, options
        end,
      },

      buffers = {
        keymap = {
          builtin = { ['<C-d>'] = false },
        },
        actions = {
          ['ctrl-x'] = false,
          ['ctrl-d'] = { fzf.actions.buf_del, fzf.actions.resume },
        },
      },
    })

    fzf.register_ui_select()
  end,

  keys = {
    -- Search

    {
      '<D-p>',
      function()
        require('fzf-lua').files({
          winopts = { title = ' Files ' },
        })
      end,
      desc = 'fzf - Files',
    },
    {
      '<D-o>',
      function()
        require('fzf-lua').buffers({
          winopts = { title = ' Open Files ' },
        })
      end,
      desc = 'fzf - Open Files',
    },

    -- Grep

    {
      '<D-g>',
      function()
        require('fzf-lua').live_grep({
          winopts = { title = ' Grep ' },
        })
      end,
      mode = 'n',
      desc = 'fzf - Live Grep',
    },
    {
      '<D-g>',
      function()
        local utils = require('fzf-lua.utils')

        require('fzf-lua').live_grep({
          search = utils.get_visual_selection(),
          winopts = { title = ' Grep ' },
        })
      end,
      mode = 'v',
      desc = 'fzf - Live Grep - Visual selection',
    },

    -- Git

    {
      '<D-b>',
      function()
        require('fzf-lua').git_branches({
          winopts = { title = ' Git Branches ' },
        })
      end,
      desc = 'fzf - Git Branches',
    },
    {
      '<D-j>',
      function()
        require('fzf-lua').git_commits({
          winopts = { title = ' Git Commits ' },
        })
      end,
      desc = 'fzf - Git Commits',
    },
    {
      '<D-S-j>',
      function()
        require('fzf-lua').git_bcommits({
          winopts = { title = ' Buffer Git Commits ' },
        })
      end,
      desc = 'fzf - Buffer Git Commits',
    },

    -- LSP

    {
      'gd',
      function()
        require('fzf-lua').lsp_definitions({
          winopts = { title = ' LSP Definitions ' },
        })
      end,
      desc = 'fzf - LSP Definitions',
    },
    {
      'gr',
      function()
        require('fzf-lua').lsp_references({
          winopts = { title = ' LSP References ' },
        })
      end,
      desc = 'fzf - LSP References',
    },
    {
      'gi',
      function()
        require('fzf-lua').lsp_implementations({
          winopts = { title = ' LSP Implementations ' },
        })
      end,
      desc = 'fzf - LSP Implementations',
    },
    {
      'ga',
      function()
        require('fzf-lua').lsp_code_actions({
          winopts = { title = ' LSP Code Actions ' },
        })
      end,
      desc = 'fzf - LSP Code Actions',
    },
    {
      '<D-f>',
      function()
        require('fzf-lua').lsp_document_diagnostics({
          winopts = { title = ' LSP Diagnostics ' },
        })
      end,
      desc = 'fzf - LSP Diagnostics',
    },
  },
}
